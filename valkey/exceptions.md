Exceptions

Core exceptions raised by the Valkey client

exception valkey.exceptions.AskError(resp)[source]

    Error indicated ASK error received from cluster. When a slot is set as MIGRATING, the node will accept all queries that pertain to this hash slot, but only if the key in question exists, otherwise the query is forwarded using a -ASK redirection to the node that is target of the migration.

    src node: MIGRATING to dst node

        get > ASK error ask dst node > ASKING command
    dst node: IMPORTING from src node

        asking command only affects next command any op will be allowed after asking command

exception valkey.exceptions.AuthenticationError[source]

exception valkey.exceptions.AuthenticationWrongNumberOfArgsError[source]

    An error to indicate that the wrong number of args were sent to the AUTH command

exception valkey.exceptions.AuthorizationError[source]

exception valkey.exceptions.BusyLoadingError[source]

exception valkey.exceptions.ChildDeadlockedError[source]

    Error indicating that a child process is deadlocked after a fork()

exception valkey.exceptions.ClusterCrossSlotError[source]

    Error indicated CROSSSLOT error received from cluster. A CROSSSLOT error is generated when keys in a request don’t hash to the same slot.

exception valkey.exceptions.ClusterDownError(resp)[source]

    Error indicated CLUSTERDOWN error received from cluster. By default Valkey Cluster nodes stop accepting queries if they detect there is at least a hash slot uncovered (no available node is serving it). This way if the cluster is partially down (for example a range of hash slots are no longer covered) the entire cluster eventually becomes unavailable. It automatically returns available as soon as all the slots are covered again.

exception valkey.exceptions.ClusterError[source]

    Cluster errors occurred multiple times, resulting in an exhaustion of the command execution TTL

exception valkey.exceptions.ConnectionError[source]

exception valkey.exceptions.DataError[source]

exception valkey.exceptions.ExecAbortError[source]

exception valkey.exceptions.InvalidResponse[source]

exception valkey.exceptions.LockError(message=None, lock_name=None)[source]

    Errors acquiring or releasing a lock

exception valkey.exceptions.LockNotOwnedError(message=None, lock_name=None)[source]

    Error trying to extend or release a lock that is (no longer) owned

exception valkey.exceptions.MasterDownError(resp)[source]

    Error indicated MASTERDOWN error received from cluster. Link with MASTER is down and replica-serve-stale-data is set to ‘no’.

exception valkey.exceptions.MaxConnectionsError[source]

exception valkey.exceptions.ModuleError[source]

exception valkey.exceptions.MovedError(resp)[source]

    Error indicated MOVED error received from cluster. A request sent to a node that doesn’t serve this key will be replayed with a MOVED error that points to the correct node.

exception valkey.exceptions.NoPermissionError[source]

exception valkey.exceptions.NoScriptError[source]

exception valkey.exceptions.OutOfMemoryError[source]

    Indicates the database is full. Can only occur when either:

            Valkey maxmemory-policy=noeviction

            Valkey maxmemory-policy=volatile* and there are no evictable keys

    For more information see Memory optimization in Valkey. # noqa

exception valkey.exceptions.PubSubError[source]

exception valkey.exceptions.ReadOnlyError[source]

exception valkey.exceptions.ResponseError[source]

exception valkey.exceptions.SlotNotCoveredError[source]

    This error only happens in the case where the connection pool will try to fetch what node that is covered by a given slot.

    If this error is raised the client should drop the current node layout and attempt to reconnect and refresh the node layout again

exception valkey.exceptions.TimeoutError[source]

exception valkey.exceptions.TryAgainError(*args, **kwargs)[source]

    Error indicated TRYAGAIN error received from cluster. Operations on keys that don’t exist or are - during resharding - split between the source and destination nodes, will generate a -TRYAGAIN error.

exception valkey.exceptions.ValkeyClusterException[source]

    Base exception for the ValkeyCluster client

exception valkey.exceptions.ValkeyError[source]

exception valkey.exceptions.WatchError