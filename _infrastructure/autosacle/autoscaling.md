Auto-Scaling Implementation Guide for Celery/Redis and Valkey/Pulsar Pipelines
This document outlines a production-ready auto-scaling strategy for a microservices stack using Celery (with Redis/Valkey) and Apache Pulsar, running on Kubernetes (GKE/EKS) with Docker. It describes when and how horizontal vs. vertical scaling is triggered, details each pipeline’s task flow, shows how Prometheus and OpenTelemetry (Otel) are integrated into the feedback loop, presents YAML templates for KEDA ScaledObjects and VPA, and explains best practices (cache continuity, no downtime). The target audience is DevOps engineers or backend developers familiar with Kubernetes and message-based systems.
Horizontal vs. Vertical Scaling
Horizontal scaling (scale out) adds or removes pod replicas in response to workload changes (e.g. queue length, message backlog, CPU). It is triggered by external metrics and events. For example, KEDA can monitor the length of a Redis list or Pulsar subscription backlog, and spin up more worker pods when those metrics exceed a threshold
thinhdanggroup.github.io
keda.sh
. In Kubernetes, a Horizontal Pod Autoscaler (HPA) can also react to CPU usage or custom metrics. Horizontal scaling improves throughput by parallelizing work across more instances. Vertical scaling (scale up) adjusts the CPU/memory resources within each pod. The Kubernetes Vertical Pod Autoscaler (VPA) watches historical CPU/memory usage and increases a pod’s resource requests/limits when it detects sustained pressure
kubecost.com
. In effect, VPA makes each worker “bigger” if needed, rather than adding more workers. VPA is best for improving performance of a single pod under heavy load. Importantly, VPA and HPA differ: HPA scales the number of pods, while VPA changes resource allocations of each pod
kubecost.com
. (Note: since HPA and VPA can conflict if driven by the same CPU/memory metrics, use custom metrics or disable one when using the other
kubecost.com
.) When to trigger which: In practice, use horizontal scaling to match changing workload (e.g. spike in queue length or message events) and vertical scaling to handle resource-intensive tasks. For instance, if Celery workers are all busy and the Redis queue grows, KEDA/HPA will add more worker pods. If an individual Celery pod is saturated on CPU despite idle cluster capacity, VPA can increase its CPU request. In general, threshold-crossing of queue/backlog or CPU usage triggers scaling: when demand rises above configured limits, KEDA/HPA adds pods; when per-pod resource usage stays high, VPA increases resources (possibly requiring pod restart). After load recedes, KEDA/HPA will scale down pods (subject to cooldown), and VPA may adjust resources downward during idle periods.
Pipeline Task Flows
Celery + Redis (Valkey) Pipeline
Task enqueue: Clients or producers submit tasks to Celery by pushing messages into the Redis (or Valkey) broker. Tasks reside in a Redis list or stream (e.g. a “celery” list or specific queue).
Worker consumption: Celery worker pods pull tasks from Redis and execute them, then optionally write results back to a result store.
Horizontal scaling: KEDA uses the Redis Lists scaler to monitor the length of the Redis queue (list). If the number of pending tasks exceeds a threshold, KEDA’s ScaledObject will increase the Deployment’s replicas. Conversely, it will scale down when backlog clears
keda.sh
thinhdanggroup.github.io
.
Vertical scaling: Meanwhile, the VPA watches each worker’s CPU/memory usage and periodically adjusts resource requests. For example, if a Celery worker consistently uses near 100% CPU, VPA will raise its CPU request, ensuring Kubernetes schedules it on a machine with sufficient capacity.
Monitoring: Prometheus (with Celery/Redis exporters or Otel instrumentation) collects metrics like Redis queue length, Celery task counts, and pod CPU. These feed the KEDA scalers (via Prometheus queries or KEDA triggers) and can also be visualized in Grafana. Otel instrumentation within Celery tasks can provide additional metrics or traces for debugging but also contribute to the metrics pipeline.
KEDA’s Redis trigger spec (shown below) is used to scale Celery workers based on queue length
keda.sh
thinhdanggroup.github.io
:
apiVersion: keda.sh/v1alpha1
kind: ScaledObject
metadata:
name: celery-scaledobject
namespace: default
spec:
scaleTargetRef:
kind: Deployment
name: celery-worker
pollingInterval: 5
cooldownPeriod: 20
minReplicaCount: 1
maxReplicaCount: 10
triggers: - type: redis
metadata:
address: redis.default:6379
password: "<REDIS_PASSWORD>"
listName: celery # name of the Redis list to watch
listLength: "20" # target length per pod
This ScaledObject tells KEDA to keep ~20 tasks per Celery worker on average
keda.sh
. As tasks pile up in Redis, additional pods spin up to maintain this average.
Valkey + Pulsar Pipeline
Task publish: Producers send messages/events to Apache Pulsar topics. (Valkey may act as a Redis-compatible intermediate broker or cache for tasks, but primary messaging is via Pulsar.) Pulsar topics are configured (possibly partitioned) and subscriptions are created for consumer groups.
Subscription backlog: As producers flood topics, messages accumulate in Pulsar. Each consumer subscription has a backlog: the number of messages not yet acknowledged. This backlog metric (pulsar_subscription_back_log) can be monitored.
Horizontal scaling of consumers: KEDA can use a Prometheus trigger to query Pulsar backlog metrics. For example, a query like sum(pulsar_subscription_back_log{topic="persistent://public/default/my-topic"}) can drive scaling: when backlog exceeds a threshold, KEDA increases the Pulsar consumer Deployment (or Function/IO workers) replicas. Alternatively, KEDA has a built-in Pulsar scaler that directly uses the Pulsar admin API and a msgBacklogThreshold
keda.sh
, which similarly triggers scaling based on the number of unacknowledged messages.
Vertical scaling: Pulsar consumer pods (and brokers) also benefit from VPA. If a consumer pod’s CPU stays high, VPA raises its request so it runs on a larger node. This helps handle bursts without needing too many pods.
Monitoring: Pulsar brokers and consumers export Prometheus metrics (see Pulsar documentation
pulsar.apache.org
). Otel may be used to instrument in-app logic on top of Pulsar (e.g. latency), but key metrics like backlog and throughput come from Pulsar’s Prometheus exporter. These metrics feed KEDA (via Prometheus queries) and standard HPA as custom metrics.
A KEDA ScaledObject using Prometheus might look like:
apiVersion: keda.sh/v1alpha1
kind: ScaledObject
metadata:
name: pulsar-scaledobject
namespace: default
spec:
scaleTargetRef:
kind: Deployment
name: pulsar-consumer
pollingInterval: 15
cooldownPeriod: 30
minReplicaCount: 1
maxReplicaCount: 10
triggers: - type: prometheus
metadata:
serverAddress: http://prometheus:9090
metricName: pulsar_subscription_back_log
threshold: "1000"
query: sum(pulsar_subscription_back_log{topic="persistent://public/default/my-topic"})
This example scales the pulsar-consumer Deployment based on the total backlog for the given topic. When the sum of backlogged messages exceeds 1000, KEDA will increase pods. (We assume Pulsar is configured to expose pulsar_subscription_back_log; see Pulsar docs
pulsar.apache.org
.) KEDA’s dedicated Pulsar trigger (not shown here) can also be used: it monitors msgBacklogThreshold on a subscription and scales when exceeded
keda.sh
. Both approaches ensure that as events arrive faster than they can be processed, new consumer pods come online.
Monitoring Integration (Prometheus and OpenTelemetry)
All components emit metrics which feed into the autoscaling logic:
Prometheus: Deployed in-cluster (or via managed service) to scrape metrics from Celery (through exporters or Otel), Redis/Valkey, and Pulsar (brokers and bookies). Key metrics are external cues for KEDA triggers: for example, the length of Redis lists (via a Celery exporter or direct Redis exporter) and Pulsar backlog (via Pulsar’s Prometheus interface). Prometheus can also power HPA using custom metrics, but here we focus on KEDA triggers which poll Prometheus as shown.
OpenTelemetry: Instrumentation libraries can be added to Celery worker and Pulsar consumer code. Otel spans/traces allow you to see request flow and latency, but importantly it can also emit metrics (e.g. number of tasks processed, durations). These metrics can be exported to Prometheus (via the Otel Collector) for dashboarding and might be used by custom scalers if needed. However, for scaling we rely primarily on queue lengths and backlog from Prometheus, rather than high-cardinality traces.
Scaling loop: The autoscaler loop is: metrics → Prometheus → KEDA/HPA decision → Kubernetes API adjusts replicas or resources. In KEDA, ScaledObjects poll Prometheus at a defined interval. KEDA’s own metrics adapter also exposes Prometheus-friendly metrics on /metrics for integration with HPA or dashboards.
By integrating these, we ensure scaling responds to real workload signals. For example, if Celery tasks are slow (detected via Otel), that might show as a growing Redis queue length, triggering scale-up. If Pulsar consumers lag (high backlog), the Prometheus query picks that up. Meanwhile, resource usage (CPU/memory) is also scraped and used by VPA to adjust pod sizes.
Trade-offs of Layered Auto-Scaling
This multi-layered approach has advantages and drawbacks:
Pros:
Responsive scaling: KEDA provides event-driven scaling (fast scale-out when queues/backlogs appear)
thinhdanggroup.github.io
keda.sh
. VPA ensures pods have enough resources for changing loads without manual tuning.
Efficiency: By combining HPA (via KEDA triggers) and VPA, resources are used efficiently. Idle pods can shrink (via VPA recommendations or lower CPU limits) and excess replicas are removed when queues empty.
Reduced waste: VPA avoids overprovisioning by right-sizing pods. Horizontal scaling avoids bottlenecks.
Zero-downtime: Adding pods or brokers is non-disruptive; new pods join seamlessly. Pulsar’s load balancer redistributes topics when brokers change
docs.datastax.com
.
Cons:
Complexity: This setup is more complex. You must configure multiple autoscalers, metrics pipelines, and possibly KEDA External Scalers. Testing and tuning is non-trivial.
Latency in scaling: Queue-length triggers are inherently reactive. For Celery, tasks only start scaling once already queued, possibly delaying response under sudden load
github.com
. (An external scaler using Celery heartbeat metrics can be faster, but is more complex.)
HPA-VPA interplay: Because VPA adjusts CPU/memory, you can’t safely use HPA on those same metrics without careful configuration
kubecost.com
. For example, an HPA targeting CPU usage can conflict with VPA’s changes. One solution is to use different (external) metrics for HPA, or disable HPA while VPA is autoscaling.
Scaling jitter: Improper thresholds can cause pod flapping (pods repeatedly coming and going). Cooldown periods and stabilization windows must be tuned.
Stateful components: Redis or Valkey clusters must handle peers joining/leaving. Ensuring continuous cache keys means using clustered Redis/Valkey with persistence; you cannot just scale the Redis broker itself in the same way. Pulsar scaling adds brokers but requires a healthy underlying Zookeeper/BookKeeper cluster to remain available.
In summary, this design is powerful but requires careful configuration of metrics and thresholds. The benefits of event-driven scaling and resource efficiency must be weighed against the increased architectural complexity.
Recommended YAML Configuration Templates
Below are example Kubernetes YAML templates for key components. They should be customized for your namespace, labels, and exact metric names.
KEDA ScaledObject for Celery (Redis): Scales a Celery worker deployment (celery-worker) based on Redis list length
keda.sh
.
apiVersion: keda.sh/v1alpha1
kind: ScaledObject
metadata:
name: celery-scaledobject
namespace: default
spec:
scaleTargetRef:
kind: Deployment
name: celery-worker
pollingInterval: 5
cooldownPeriod: 20
minReplicaCount: 1
maxReplicaCount: 10
triggers: - type: redis
metadata:
address: redis.default:6379
password: "<REDIS_PASSWORD>"
listName: celery # Redis list used by Celery
listLength: "20" # target tasks per worker
KEDA ScaledObject for Pulsar (Prometheus): Scales a Pulsar consumer deployment (pulsar-consumer) using a Prometheus query on the Pulsar backlog. Adjust serverAddress, query, and thresholds as needed.
apiVersion: keda.sh/v1alpha1
kind: ScaledObject
metadata:
name: pulsar-scaledobject
namespace: default
spec:
scaleTargetRef:
kind: Deployment
name: pulsar-consumer
pollingInterval: 15
cooldownPeriod: 30
minReplicaCount: 1
maxReplicaCount: 10
triggers: - type: prometheus
metadata:
serverAddress: http://prometheus:9090
metricName: pulsar_subscription_back_log
threshold: "1000"
query: sum(pulsar_subscription_back_log{topic="persistent://public/default/my-topic"})
VPA for a worker deployment: Applies VPA to each worker deployment (Celery or Pulsar consumer). For example, the Celery worker deployment can have a VPA like this, which allows resources to grow/shrink within min/max bounds (update mode Auto applies changes by restarting pods gradually)
kubecost.com
:
apiVersion: autoscaling.k8s.io/v1
kind: VerticalPodAutoscaler
metadata:
name: celery-worker-vpa
namespace: default
spec:
targetRef:
apiVersion: "apps/v1"
kind: Deployment
name: celery-worker
updatePolicy:
updateMode: "Auto"
resourcePolicy:
containerPolicies: - containerName: celery
minAllowed:
cpu: "100m"
memory: "256Mi"
maxAllowed:
cpu: "2000m"
memory: "1Gi"
Similar VPA configs can be made for Pulsar consumers or any other worker. They ensure that if a pod’s usage consistently exceeds its request, Kubernetes will restart it with larger allocation.
Pulsar Broker Deployment (StatefulSet): A sample StatefulSet for Pulsar brokers (set replicas to desired count). It uses the official Pulsar image and configures readiness probes on the admin port to avoid downtime when scaling. (In production, also run BookKeeper and Zookeeper nodes; this example focuses on brokers only.)
apiVersion: apps/v1
kind: StatefulSet
metadata:
name: pulsar-broker
namespace: pulsar
spec:
serviceName: pulsar-broker
replicas: 2
selector:
matchLabels:
app: pulsar-broker
template:
metadata:
labels:
app: pulsar-broker
spec:
containers: - name: broker
image: apachepulsar/pulsar:latest
args: ["bin/pulsar", "broker", "--no-functions-worker"]
ports: - containerPort: 6650 # Pulsar binary protocol - containerPort: 8080 # Pulsar HTTP service (admin/metrics)
readinessProbe:
httpGet:
path: /metrics
port: 8080
initialDelaySeconds: 30
periodSeconds: 60
resources:
requests:
cpu: "500m"
memory: "1Gi"
limits:
cpu: "1000m"
memory: "2Gi"
This StatefulSet ensures brokers can be scaled without losing metadata. When a new broker pod comes up, Pulsar’s load balancer will automatically assign topic bundles to it. The readiness probe on /metrics ensures the pod is only marked ready after the broker service is up, preventing downtime during scale events
docs.datastax.com
.
Scaling Event Sequence
A typical scale-up / scale-down cycle proceeds as follows:
Monitoring: Prometheus continually scrapes metrics:
Celery pipeline: Redis list length (pending tasks), Celery worker CPU/memory, etc.
Pulsar pipeline: Pulsar subscription backlog (pulsar_subscription_back_log), broker CPU load, etc.
Trigger Detection: When a metric exceeds its threshold (e.g. Redis list length > listLength target, or Pulsar backlog > threshold) for a sustained period, KEDA/Kubernetes decides to scale out.
Celery: KEDA’s Redis trigger notices queue length rising, so it increments the celery-worker replicas (up to maxReplicaCount)
thinhdanggroup.github.io
.
Pulsar: KEDA’s Prometheus trigger sees backlog grow, so it adds more consumer pods. Alternatively, a Pulsar operator can scale brokers if CPU/load is high
docs.datastax.com
.
Pod Startup: New pods (Celery or Pulsar consumer) are scheduled. They connect to Redis/Pulsar and begin processing tasks. Readiness probes ensure they don’t receive traffic until ready. Any persistent volume claims for pods (if used) are bound.
Resource Adjustment: Meanwhile, VPA may recommend higher resource requests for pods showing high usage. If updateMode: Auto, it will restart pods with updated requests (one at a time). This usually happens after a scale-out or when usage changes significantly.
Cooldown and Stabilization: Once the workload stabilizes (e.g. Celery queue drains or Pulsar backlog clears) for the cooldown window, KEDA/HPA will scale pods down. Pods are terminated gracefully, finishing in-flight tasks before exit.
Scale-Down: Pods are removed one by one. For Celery, workers finish any current task then exit. For Pulsar, consumers close subscriptions. Brokers can be scaled down by setting StatefulSet replicas lower or via operator when underutilized.
State Continuity: Throughout, Redis/Valkey (and Pulsar topics) retain all tasks/messages. Scaling workers in/out does not lose tasks because:
Pending tasks stay in Redis lists (Redis should use a persistent volume or HA cluster so data isn’t lost on pod restart).
Pulsar retains messages until acknowledged by consumers, so adding/removing consumers simply shifts which consumer reads each message next.
We ensure Valkey/Redis keys persist by not re-initializing the datastore on scaling; use a stable cluster endpoint rather than ephemeral pods.
By following these steps, autoscaling reacts to real-time metrics and keeps the system responsive without interrupting service.
Preventing Downtime and Preserving State
Redis/Valkey continuity: Use a durable Redis/Valkey setup (StatefulSet or managed service) so that data (keys, queues) survives pod restarts. Do not rely on the Celery broker pod for persistence. Celery workers are stateless and can come and go; all state is in Redis. Even if workers are drained or restarted by VPA, they will resume pulling tasks from the same Redis lists.
Pulsar scaling: Apache Pulsar is designed for dynamic scaling. Brokers can be added or removed without downtime: when you increase the broker StatefulSet count, new brokers join and the Pulsar load balancer assigns them topic bundles
docs.datastax.com
. Consumers similarly rebalance across brokers. Ensure you have a stable BookKeeper cluster and enough replicas for metadata; then scaling brokers or consumers is transparent. Using readiness probes (as above) and StatefulSet ensures old pods are only terminated after new ones are healthy.
Rolling updates: If you update the broker image or config, use Kubernetes rolling updates. New broker pods will join the cluster before old ones are deleted. The Pulsar operators or Helm charts (e.g. the official Helm chart) can manage this more seamlessly than a raw deployment, but the principle is the same.
By decoupling state (Redis/Valkey, Pulsar topics) from compute (pods), and using Kubernetes primitives (StatefulSets, probes), we can scale all components up and down without dropping messages or losing keys. This maintains continuity during autoscaling.
References: Kubernetes/VPA official docs
kubecost.com
kubecost.com
; KEDA Redis and Pulsar scaler docs
keda.sh
keda.sh
; DataStax Pulsar Autoscaler guide
docs.datastax.com
; Celery/KEDA scaler best practices
thinhdanggroup.github.io
github.com
. Each provided snippet is a recommended example and should be adapted for your specific namespace, labels, and security settings.
Citations
Favicon
Effortless Auto-Scaling of Celery Workers with KEDA and Redis on Kubernetes - ThinhDA

https://thinhdanggroup.github.io/blog-on-auto-scaling-celery-tasks/
Favicon
Apache Pulsar | KEDA

https://keda.sh/docs/2.13/scalers/pulsar/
Favicon
The Guide To Kubernetes VPA by Example

https://www.kubecost.com/kubernetes-autoscaling/kubernetes-vpa/
Favicon
The Guide To Kubernetes VPA by Example

https://www.kubecost.com/kubernetes-autoscaling/kubernetes-vpa/
Favicon
The Guide To Kubernetes VPA by Example

https://www.kubecost.com/kubernetes-autoscaling/kubernetes-vpa/
Favicon
Redis Lists | KEDA

https://keda.sh/docs/1.4/scalers/redis-lists/
Favicon
Pulsar metrics | Apache Pulsar

https://pulsar.apache.org/docs/next/reference-metrics/
Favicon
Broker autoscaler | Kubernetes Autoscaling for Apache Pulsar | DataStax Docs

https://docs.datastax.com/en/kaap-operator/0.2.0/scaling-components/autoscale-brokers.html
Favicon
GitHub - klippa-app/keda-celery-scaler: Autoscale your Celery workers based on your actual load with KEDA

https://github.com/klippa-app/keda-celery-scaler
Favicon
The Guide To Kubernetes VPA by Example

https://www.kubecost.com/kubernetes-autoscaling/kubernetes-vpa/
