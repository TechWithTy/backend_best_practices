Retry Helpers
class valkey.retry.Retry(backoff, retries, supported_errors=(<class 'valkey.exceptions.ConnectionError'>, <class 'valkey.exceptions.TimeoutError'>, <class 'socket.timeout'>))[source]

Retry a specific number of times after a failure

Parameters

        backoff (AbstractBackoff) –

        retries (int) –

        supported_errors (Tuple[Type[Exception], ...]) –

call_with_retry(do, fail)[source]

    Execute an operation that might fail and returns its result, or raise the exception that was thrown depending on the Backoff object. do: the operation to call. Expects no argument. fail: the failure handler, expects the last error that was thrown

    Parameters

            do (Callable[[], T]) –

            fail (Callable[[Exception], Any]) –

    Return type

        T

update_supported_errors(specified_errors)[source]

        Updates the supported errors with the specified error types

        Parameters

            specified_errors (Iterable[Type[Exception]]) –
        Return type

            None

Retry in Valkey Standalone

from valkey.backoff import ExponentialBackoff

from valkey.retry import Retry

from valkey.client import Valkey

from valkey.exceptions import (

   BusyLoadingError,

   ConnectionError,

   TimeoutError

)


# Run 3 retries with exponential backoff strategy

retry = Retry(ExponentialBackoff(), 3)

# Valkey client with retries on custom errors

r = Valkey(host='localhost', port=6379, retry=retry, retry_on_error=[BusyLoadingError, ConnectionError, TimeoutError])

# Valkey client with retries on TimeoutError only

r_only_timeout = Valkey(host='localhost', port=6379, retry=retry, retry_on_timeout=True)

As you can see from the example above, Valkey client supports 3 parameters to configure the retry behaviour:

    retry: Retry instance with a Backoff strategy and the max number of retries

    retry_on_error: list of Exceptions to retry on

    retry_on_timeout: if True, retry on TimeoutError only

If either retry_on_error or retry_on_timeout are passed and no retry is given, by default it uses a Retry(NoBackoff(), 1) (meaning 1 retry right after the first failure).
Retry in Valkey Cluster

from valkey.backoff import ExponentialBackoff

from valkey.retry import Retry

from valkey.cluster import ValkeyCluster


# Run 3 retries with exponential backoff strategy

retry = Retry(ExponentialBackoff(), 3)

# Valkey Cluster client with retries

rc = ValkeyCluster(host='localhost', port=6379, retry=retry, cluster_error_retry_attempts=2)

Retry behaviour in Valkey Cluster is a little bit different from Standalone:

    retry: Retry instance with a Backoff strategy and the max number of retries, default value is Retry(NoBackoff(), 0)

    cluster_error_retry_attempts: number of times to retry before raising an error when TimeoutError or ConnectionError or ClusterDownError are encountered, default value is 3

Let’s consider the following example:

from valkey.backoff import ExponentialBackoff

from valkey.retry import Retry

from valkey.cluster import ValkeyCluster


rc = ValkeyCluster(host='localhost', port=6379, retry=Retry(ExponentialBackoff(), 6), cluster_error_retry_attempts=1)

rc.set('foo', 'bar')

    the client library calculates the hash slot for key ‘foo’.

    given the hash slot, it then determines which node to connect to, in order to execute the command.

    during the connection, a ConnectionError is raised.

    because we set retry=Retry(ExponentialBackoff(), 6), the client tries to reconnect to the node up to 6 times, with an exponential backoff between each attempt.

    even after 6 retries, the client is still unable to connect.

    because we set cluster_error_retry_attempts=1, before giving up, the client starts a cluster update, removes the failed node from the startup nodes, and re-initializes the cluster.

    after the cluster has been re-initialized, it starts a new cycle of retries, up to 6 retries, with an exponential backoff.

    if the client can connect, we’re good. Otherwise, the exception is finally raised to the caller, because we’ve run out of attempts.
