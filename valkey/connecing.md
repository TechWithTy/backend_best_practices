Connecting to Valkey
Generic Client

This is the client used to connect directly to a standard Valkey node.

class valkey.Valkey(host='localhost', port=6379, db=0, password=None, socket_timeout=None, socket_connect_timeout=None, socket_keepalive=None, socket_keepalive_options=None, connection_pool=None, unix_socket_path=None, encoding='utf-8', encoding_errors='strict', charset=None, errors=None, decode_responses=False, retry_on_timeout=False, retry_on_error=None, ssl=False, ssl_keyfile=None, ssl_certfile=None, ssl_cert_reqs='required', ssl_ca_certs=None, ssl_ca_path=None, ssl_ca_data=None, ssl_check_hostname=False, ssl_password=None, ssl_validate_ocsp=False, ssl_validate_ocsp_stapled=False, ssl_ocsp_context=None, ssl_ocsp_expected_cert=None, ssl_min_version=None, ssl_ciphers=None, max_connections=None, single_connection_client=False, health_check_interval=0, client_name=None, lib_name='valkey-py', lib_version='99.99.99', username=None, retry=None, valkey_connect_func=None, credential_provider=None, protocol=2, cache_enabled=False, client_cache=None, cache_max_size=10000, cache_ttl=0, cache_policy=EvictionPolicy.LRU, cache_deny_list=['BF.CARD', 'BF.DEBUG', 'BF.EXISTS', 'BF.INFO', 'BF.MEXISTS', 'BF.SCANDUMP', 'CF.COMPACT', 'CF.COUNT', 'CF.DEBUG', 'CF.EXISTS', 'CF.INFO', 'CF.MEXISTS', 'CF.SCANDUMP', 'CMS.INFO', 'CMS.QUERY', 'DUMP', 'EXPIRETIME', 'FT.AGGREGATE', 'FT.ALIASADD', 'FT.ALIASDEL', 'FT.ALIASUPDATE', 'FT.CURSOR', 'FT.EXPLAIN', 'FT.EXPLAINCLI', 'FT.GET', 'FT.INFO', 'FT.MGET', 'FT.PROFILE', 'FT.SEARCH', 'FT.SPELLCHECK', 'FT.SUGGET', 'FT.SUGLEN', 'FT.SYNDUMP', 'FT.TAGVALS', 'FT._ALIASADDIFNX', 'FT._ALIASDELIFX', 'HRANDFIELD', 'JSON.DEBUG', 'PEXPIRETIME', 'PFCOUNT', 'PTTL', 'SRANDMEMBER', 'TDIGEST.BYRANK', 'TDIGEST.BYREVRANK', 'TDIGEST.CDF', 'TDIGEST.INFO', 'TDIGEST.MAX', 'TDIGEST.MIN', 'TDIGEST.QUANTILE', 'TDIGEST.RANK', 'TDIGEST.REVRANK', 'TDIGEST.TRIMMED_MEAN', 'TOPK.INFO', 'TOPK.LIST', 'TOPK.QUERY', 'TOUCH', 'TTL'], cache_allow_list=['BITCOUNT', 'BITFIELD_RO', 'BITPOS', 'EXISTS', 'GEODIST', 'GEOHASH', 'GEOPOS', 'GEORADIUSBYMEMBER_RO', 'GEORADIUS_RO', 'GEOSEARCH', 'GET', 'GETBIT', 'GETRANGE', 'HEXISTS', 'HGET', 'HGETALL', 'HKEYS', 'HLEN', 'HMGET', 'HSTRLEN', 'HVALS', 'JSON.ARRINDEX', 'JSON.ARRLEN', 'JSON.GET', 'JSON.MGET', 'JSON.OBJKEYS', 'JSON.OBJLEN', 'JSON.RESP', 'JSON.STRLEN', 'JSON.TYPE', 'LCS', 'LINDEX', 'LLEN', 'LPOS', 'LRANGE', 'MGET', 'SCARD', 'SDIFF', 'SINTER', 'SINTERCARD', 'SISMEMBER', 'SMEMBERS', 'SMISMEMBER', 'SORT_RO', 'STRLEN', 'SUBSTR', 'SUNION', 'TS.GET', 'TS.INFO', 'TS.RANGE', 'TS.REVRANGE', 'TYPE', 'XLEN', 'XPENDING', 'XRANGE', 'XREAD', 'XREVRANGE', 'ZCARD', 'ZCOUNT', 'ZDIFF', 'ZINTER', 'ZINTERCARD', 'ZLEXCOUNT', 'ZMSCORE', 'ZRANGE', 'ZRANGEBYLEX', 'ZRANGEBYSCORE', 'ZRANK', 'ZREVRANGE', 'ZREVRANGEBYLEX', 'ZREVRANGEBYSCORE', 'ZREVRANK', 'ZSCORE', 'ZUNION'])[source]

Implementation of the Valkey protocol.

This abstract class provides a Python interface to all Valkey commands and an implementation of the Valkey protocol.

Pipelines derive from this, implementing how the commands are sent and received to the Valkey server. Based on configuration, an instance will either use a ConnectionPool, or Connection object to talk to valkey.

It is not safe to pass PubSub or Pipeline objects between threads.

Parameters

        credential_provider (Optional[CredentialProvider]) –

        protocol (Optional[int]) –

        cache_enabled (bool) –

        client_cache (Optional[AbstractCache]) –

        cache_max_size (int) –

        cache_ttl (int) –

        cache_policy (str) –

        cache_deny_list (List[str]) –

        cache_allow_list (List[str]) –

execute_command(*args, **options)[source]

    Execute a command and return a parsed response

classmethod from_pool(connection_pool)[source]

    Return a Valkey client from the given connection pool. The Valkey client will take ownership of the connection pool and close it when the Valkey client is closed.

    Parameters

        connection_pool (ConnectionPool) –
    Return type

        Valkey

classmethod from_url(url, **kwargs)[source]

    Return a Valkey client object configured from the given URL

    For example:

    valkey://[[username]:[password]]@localhost:6379/0
    valkeys://[[username]:[password]]@localhost:6379/0
    unix://[username@]/path/to/socket.sock?db=0[&password=password]

    Three URL schemes are supported:

        valkey:// creates a TCP socket connection.

        valkeys:// creates a SSL wrapped TCP socket connection.

        unix://: creates a Unix Domain Socket connection.

    The username, password, hostname, path and all querystring values are passed through urllib.parse.unquote in order to replace any percent-encoded values with their corresponding characters.

    There are several ways to specify a database number. The first value found will be used:

            A db querystring option, e.g. valkey://localhost?db=0

            If using the valkey:// or valkeys:// schemes, the path argument of the url, e.g. valkey://localhost/0

            A db keyword argument to this function.

    If none of these options are specified, the default db=0 is used.

    All querystring options are cast to their appropriate Python types. Boolean arguments can be specified with string values “True”/”False” or “Yes”/”No”. Values that cannot be properly cast cause a ValueError to be raised. Once parsed, the querystring arguments and keyword arguments are passed to the ConnectionPool’s class initializer. In the case of conflicting arguments, querystring arguments always win.

    Parameters

        url (str) –
    Return type

        Valkey

get_connection_kwargs()[source]

    Get the connection’s key-word arguments

    Return type

        Dict

get_encoder()[source]

    Get the connection pool’s encoder

    Return type

        Encoder

load_external_module(funcname, func)[source]

    This function can be used to add externally defined valkey modules, and their namespaces to the valkey client.

    funcname - A string containing the name of the function to create func - The function, being added to this class.

    ex: Assume that one has a custom valkey module named foomod that creates command named ‘foo.dothing’ and ‘foo.anotherthing’ in valkey. To load function functions into this namespace:

    from valkey import Valkey from foomodule import F r = Valkey() r.load_external_module(“foo”, F) r.foo().dothing(‘your’, ‘arguments’)

    For a concrete example see the reimport of the redisjson module in tests/test_connection.py::test_loading_external_modules

    Return type

        None

lock(name, timeout=None, sleep=0.1, blocking=True, blocking_timeout=None, lock_class=None, thread_local=True)[source]

    Return a new Lock object using key name that mimics the behavior of threading.Lock.

    If specified, timeout indicates a maximum life for the lock. By default, it will remain locked until release() is called.

    sleep indicates the amount of time to sleep per loop iteration when the lock is in blocking mode and another client is currently holding the lock.

    blocking indicates whether calling acquire should block until the lock has been acquired or to fail immediately, causing acquire to return False and the lock not being acquired. Defaults to True. Note this value can be overridden by passing a blocking argument to acquire.

    blocking_timeout indicates the maximum amount of time in seconds to spend trying to acquire the lock. A value of None indicates continue trying forever. blocking_timeout can be specified as a float or integer, both representing the number of seconds to wait.

    lock_class forces the specified lock implementation. Note that the only lock class we implement is Lock (which is a Lua-based lock). So, it’s unlikely you’ll need this parameter, unless you have created your own custom lock class.

    thread_local indicates whether the lock token is placed in thread-local storage. By default, the token is placed in thread local storage so that a thread only sees its token, not a token set by another thread. Consider the following timeline:

        time: 0, thread-1 acquires my-lock, with a timeout of 5 seconds.

            thread-1 sets the token to “abc”
        time: 1, thread-2 blocks trying to acquire my-lock using the

            Lock instance.
        time: 5, thread-1 has not yet completed. valkey expires the lock

            key.
        time: 5, thread-2 acquired my-lock now that it’s available.

            thread-2 sets the token to “xyz”
        time: 6, thread-1 finishes its work and calls release(). if the

            token is not stored in thread local storage, then thread-1 would see the token value as “xyz” and would be able to successfully release the thread-2’s lock.

    In some use cases it’s necessary to disable thread local storage. For example, if you have code where one thread acquires a lock and passes that lock instance to a worker thread to release later. If thread local storage isn’t disabled in this case, the worker thread won’t see the token set by the thread that acquired the lock. Our assumption is that these cases aren’t common and as such default to using thread local storage.

    Parameters

            name (str) –

            timeout (Optional[float]) –

            sleep (float) –

            blocking (bool) –

            blocking_timeout (Optional[float]) –

            lock_class (Union[None, Any]) –

            thread_local (bool) –

parse_response(connection, command_name, **options)[source]

    Parses a response from the Valkey server

pipeline(transaction=True, shard_hint=None)[source]

    Return a new pipeline object that can queue multiple commands for later execution. transaction indicates whether all commands should be executed atomically. Apart from making a group of operations atomic, pipelines are useful for reducing the back-and-forth overhead between the client and server.

    Return type

        Pipeline

pubsub(**kwargs)[source]

    Return a Publish/Subscribe object. With this object, you can subscribe to channels and listen for messages that get published to them.

set_response_callback(command, callback)[source]

    Set a custom Response Callback

    Parameters

            command (str) –

            callback (Callable) –

    Return type

        None

transaction(func, *watches, **kwargs)[source]

        Convenience method for executing the callable func as a transaction while watching all keys specified in watches. The ‘func’ callable should expect a single argument which is a Pipeline object.

        Parameters

            func (Callable[[Pipeline], None]) –
        Return type

            None

Sentinel Client

Valkey Sentinel provides high availability for Valkey. There are commands that can only be executed against a Valkey node running in sentinel mode. Connecting to those nodes, and executing commands against them requires a Sentinel connection.

Connection example (assumes Valkey exists on the ports listed below):

from valkey import Sentinel

sentinel = Sentinel([('localhost', 26379)], socket_timeout=0.1)

sentinel.discover_master('mymaster')
('127.0.0.1', 6379)

sentinel.discover_slaves('mymaster')
[('127.0.0.1', 6380)]

Sentinel
class valkey.sentinel.Sentinel(sentinels, min_other_sentinels=0, sentinel_kwargs=None, **connection_kwargs)[source]

Valkey Sentinel cluster client

from valkey.sentinel import Sentinel

sentinel = Sentinel([('localhost', 26379)], socket_timeout=0.1)

master = sentinel.master_for('mymaster', socket_timeout=0.1)

master.set('foo', 'bar')

slave = sentinel.slave_for('mymaster', socket_timeout=0.1)

slave.get('foo')
b'bar'

sentinels is a list of sentinel nodes. Each node is represented by a pair (hostname, port).

min_other_sentinels defined a minimum number of peers for a sentinel. When querying a sentinel, if it doesn’t meet this threshold, responses from that sentinel won’t be considered valid.

sentinel_kwargs is a dictionary of connection arguments used when connecting to sentinel instances. Any argument that can be passed to a normal Valkey connection can be specified here. If sentinel_kwargs is not specified, any socket_timeout and socket_keepalive options specified in connection_kwargs will be used.

connection_kwargs are keyword arguments that will be used when establishing a connection to a Valkey server.

discover_master(service_name)[source]

    Asks sentinel servers for the Valkey master’s address corresponding to the service labeled service_name.

    Returns a pair (address, port) or raises MasterNotFoundError if no master is found.

discover_slaves(service_name)[source]

    Returns a list of alive slaves for service service_name

execute_command(*args, **kwargs)[source]

    Execute Sentinel command in sentinel nodes. once - If set to True, then execute the resulting command on a single node at random, rather than across the entire sentinel cluster.

filter_slaves(slaves)[source]

    Remove slaves that are in an ODOWN or SDOWN state

master_for(service_name, valkey_class=<class 'valkey.client.Valkey'>, connection_pool_class=<class 'valkey.sentinel.SentinelConnectionPool'>, **kwargs)[source]

    Returns a valkey client instance for the service_name master.

    A SentinelConnectionPool class is used to retrieve the master’s address before establishing a new connection.

    NOTE: If the master’s address has changed, any cached connections to the old master are closed.

    By default clients will be a Valkey instance. Specify a different class to the valkey_class argument if you desire something different.

    The connection_pool_class specifies the connection pool to use. The SentinelConnectionPool will be used by default.

    All other keyword arguments are merged with any connection_kwargs passed to this class and passed to the connection pool as keyword arguments to be used to initialize Valkey connections.

slave_for(service_name, valkey_class=<class 'valkey.client.Valkey'>, connection_pool_class=<class 'valkey.sentinel.SentinelConnectionPool'>, **kwargs)[source]

        Returns valkey client instance for the service_name slave(s).

        A SentinelConnectionPool class is used to retrieve the slave’s address before establishing a new connection.

        By default clients will be a Valkey instance. Specify a different class to the valkey_class argument if you desire something different.

        The connection_pool_class specifies the connection pool to use. The SentinelConnectionPool will be used by default.

        All other keyword arguments are merged with any connection_kwargs passed to this class and passed to the connection pool as keyword arguments to be used to initialize Valkey connections.

SentinelConnectionPool
class valkey.sentinel.SentinelConnectionPool(service_name, sentinel_manager, **kwargs)[source]

Sentinel backed connection pool.

If check_connection flag is set to True, SentinelManagedConnection sends a PING command right after establishing the connection.

rotate_slaves()[source]

        Round-robin slave balancer

Cluster Client

This client is used for connecting to a Valkey Cluster.
ValkeyCluster
class valkey.cluster.ValkeyCluster(host=None, port=6379, startup_nodes=None, cluster_error_retry_attempts=3, retry=None, require_full_coverage=False, reinitialize_steps=5, read_from_replicas=False, dynamic_startup_nodes=True, url=None, address_remap=None, **kwargs)[source]

Parameters

        host (Optional[str]) –

        port (int) –

        startup_nodes (Optional[List[ClusterNode]]) –

        cluster_error_retry_attempts (int) –

        retry (Optional[Retry]) –

        require_full_coverage (bool) –

        reinitialize_steps (int) –

        read_from_replicas (bool) –

        dynamic_startup_nodes (bool) –

        url (Optional[str]) –

        address_remap (Optional[Callable[[Tuple[str, int]], Tuple[str, int]]]) –

determine_slot(*args)[source]

    Figure out what slot to use based on args.

    Raises a ValkeyClusterException if there’s a missing key and we can’t

        determine what slots to map the command to; or, if the keys don’t all map to the same key slot.

execute_command(*args, **kwargs)[source]

    Wrapper for ERRORS_ALLOW_RETRY error handling.

    It will try the number of times specified by the config option “self.cluster_error_retry_attempts” which defaults to 3 unless manually configured.

    If it reaches the number of times, the command will raise the exception

    Key argument :target_nodes: can be passed with the following types:

        nodes_flag: PRIMARIES, REPLICAS, ALL_NODES, RANDOM ClusterNode list<ClusterNode> dict<Any, ClusterNode>

classmethod from_url(url, **kwargs)[source]

    Return a Valkey client object configured from the given URL

    For example:

    valkey://[[username]:[password]]@localhost:6379/0
    valkeys://[[username]:[password]]@localhost:6379/0
    unix://[username@]/path/to/socket.sock?db=0[&password=password]

    Three URL schemes are supported:

        valkey:// creates a TCP socket connection.

        valkeys:// creates a SSL wrapped TCP socket connection.

        unix://: creates a Unix Domain Socket connection.

    The username, password, hostname, path and all querystring values are passed through urllib.parse.unquote in order to replace any percent-encoded values with their corresponding characters.

    There are several ways to specify a database number. The first value found will be used:

            A db querystring option, e.g. valkey://localhost?db=0

            If using the valkey:// or valkeys:// schemes, the path argument of the url, e.g. valkey://localhost/0

            A db keyword argument to this function.

    If none of these options are specified, the default db=0 is used.

    All querystring options are cast to their appropriate Python types. Boolean arguments can be specified with string values “True”/”False” or “Yes”/”No”. Values that cannot be properly cast cause a ValueError to be raised. Once parsed, the querystring arguments and keyword arguments are passed to the ConnectionPool’s class initializer. In the case of conflicting arguments, querystring arguments always win.

get_connection_kwargs()[source]

    Get the connections’ key-word arguments

get_default_node()[source]

    Get the cluster’s default node

get_encoder()[source]

    Get the connections’ encoder

get_node_from_key(key, replica=False)[source]

    Get the node that holds the key’s slot. If replica set to True but the slot doesn’t have any replicas, None is returned.

keyslot(key)[source]

    Calculate keyslot for a given key. See Keys distribution model in https://redis.io/topics/cluster-spec

load_external_module(funcname, func)[source]

    This function can be used to add externally defined valkey modules, and their namespaces to the valkey client.

    funcname - A string containing the name of the function to create func - The function, being added to this class.

lock(name, timeout=None, sleep=0.1, blocking=True, blocking_timeout=None, lock_class=None, thread_local=True)[source]

    Return a new Lock object using key name that mimics the behavior of threading.Lock.

    If specified, timeout indicates a maximum life for the lock. By default, it will remain locked until release() is called.

    sleep indicates the amount of time to sleep per loop iteration when the lock is in blocking mode and another client is currently holding the lock.

    blocking indicates whether calling acquire should block until the lock has been acquired or to fail immediately, causing acquire to return False and the lock not being acquired. Defaults to True. Note this value can be overridden by passing a blocking argument to acquire.

    blocking_timeout indicates the maximum amount of time in seconds to spend trying to acquire the lock. A value of None indicates continue trying forever. blocking_timeout can be specified as a float or integer, both representing the number of seconds to wait.

    lock_class forces the specified lock implementation. Note that the only lock class we implement is Lock (which is a Lua-based lock). So, it’s unlikely you’ll need this parameter, unless you have created your own custom lock class.

    thread_local indicates whether the lock token is placed in thread-local storage. By default, the token is placed in thread local storage so that a thread only sees its token, not a token set by another thread. Consider the following timeline:

        time: 0, thread-1 acquires my-lock, with a timeout of 5 seconds.

            thread-1 sets the token to “abc”
        time: 1, thread-2 blocks trying to acquire my-lock using the

            Lock instance.
        time: 5, thread-1 has not yet completed. valkey expires the lock

            key.
        time: 5, thread-2 acquired my-lock now that it’s available.

            thread-2 sets the token to “xyz”
        time: 6, thread-1 finishes its work and calls release(). if the

            token is not stored in thread local storage, then thread-1 would see the token value as “xyz” and would be able to successfully release the thread-2’s lock.

    In some use cases it’s necessary to disable thread local storage. For example, if you have code where one thread acquires a lock and passes that lock instance to a worker thread to release later. If thread local storage isn’t disabled in this case, the worker thread won’t see the token set by the thread that acquired the lock. Our assumption is that these cases aren’t common and as such default to using thread local storage.

monitor(target_node=None)[source]

    Returns a Monitor object for the specified target node. The default cluster node will be selected if no target node was specified. Monitor is useful for handling the MONITOR command to the valkey server. next_command() method returns one command from monitor listen() method yields commands from monitor.

on_connect(connection)[source]

    Initialize the connection, authenticate and select a database and send

        READONLY if it is set during object initialization.

pipeline(transaction=None, shard_hint=None)[source]

    Cluster impl:

        Pipelines do not work in cluster mode the same way they do in normal mode. Create a clone of this object so that simulating pipelines will work correctly. Each command will be called directly when used and when calling execute() will only return the result stack.

pubsub(node=None, host=None, port=None, **kwargs)[source]

    Allows passing a ClusterNode, or host&port, to get a pubsub instance connected to the specified node

set_default_node(node)[source]

    Set the default node of the cluster. :param node: ‘ClusterNode’ :return True if the default node was set, else False

set_response_callback(command, callback)[source]

        Set a custom Response Callback

ClusterNode
class valkey.cluster.ClusterNode(host, port, server_type=None, valkey_connection=None)[source]

Async Client

See complete example: here

This client is used for communicating with Valkey, asynchronously.

class valkey.asyncio.client.Valkey(*, host='localhost', port=6379, db=0, password=None, socket_timeout=5, socket_connect_timeout=None, socket_keepalive=None, socket_keepalive_options=None, connection_pool=None, unix_socket_path=None, encoding='utf-8', encoding_errors='strict', decode_responses=False, retry_on_timeout=False, retry_on_error=None, ssl=False, ssl_keyfile=None, ssl_certfile=None, ssl_cert_reqs='required', ssl_ca_certs=None, ssl_ca_data=None, ssl_check_hostname=False, ssl_min_version=None, ssl_ciphers=None, max_connections=None, single_connection_client=False, health_check_interval=0, client_name=None, lib_name='valkey-py', lib_version='99.99.99', username=None, retry=None, auto_close_connection_pool=None, valkey_connect_func=None, credential_provider=None, protocol=2, cache_enabled=False, client_cache=None, cache_max_size=100, cache_ttl=0, cache_policy=EvictionPolicy.LRU, cache_deny_list=['BF.CARD', 'BF.DEBUG', 'BF.EXISTS', 'BF.INFO', 'BF.MEXISTS', 'BF.SCANDUMP', 'CF.COMPACT', 'CF.COUNT', 'CF.DEBUG', 'CF.EXISTS', 'CF.INFO', 'CF.MEXISTS', 'CF.SCANDUMP', 'CMS.INFO', 'CMS.QUERY', 'DUMP', 'EXPIRETIME', 'FT.AGGREGATE', 'FT.ALIASADD', 'FT.ALIASDEL', 'FT.ALIASUPDATE', 'FT.CURSOR', 'FT.EXPLAIN', 'FT.EXPLAINCLI', 'FT.GET', 'FT.INFO', 'FT.MGET', 'FT.PROFILE', 'FT.SEARCH', 'FT.SPELLCHECK', 'FT.SUGGET', 'FT.SUGLEN', 'FT.SYNDUMP', 'FT.TAGVALS', 'FT._ALIASADDIFNX', 'FT._ALIASDELIFX', 'HRANDFIELD', 'JSON.DEBUG', 'PEXPIRETIME', 'PFCOUNT', 'PTTL', 'SRANDMEMBER', 'TDIGEST.BYRANK', 'TDIGEST.BYREVRANK', 'TDIGEST.CDF', 'TDIGEST.INFO', 'TDIGEST.MAX', 'TDIGEST.MIN', 'TDIGEST.QUANTILE', 'TDIGEST.RANK', 'TDIGEST.REVRANK', 'TDIGEST.TRIMMED_MEAN', 'TOPK.INFO', 'TOPK.LIST', 'TOPK.QUERY', 'TOUCH', 'TTL'], cache_allow_list=['BITCOUNT', 'BITFIELD_RO', 'BITPOS', 'EXISTS', 'GEODIST', 'GEOHASH', 'GEOPOS', 'GEORADIUSBYMEMBER_RO', 'GEORADIUS_RO', 'GEOSEARCH', 'GET', 'GETBIT', 'GETRANGE', 'HEXISTS', 'HGET', 'HGETALL', 'HKEYS', 'HLEN', 'HMGET', 'HSTRLEN', 'HVALS', 'JSON.ARRINDEX', 'JSON.ARRLEN', 'JSON.GET', 'JSON.MGET', 'JSON.OBJKEYS', 'JSON.OBJLEN', 'JSON.RESP', 'JSON.STRLEN', 'JSON.TYPE', 'LCS', 'LINDEX', 'LLEN', 'LPOS', 'LRANGE', 'MGET', 'SCARD', 'SDIFF', 'SINTER', 'SINTERCARD', 'SISMEMBER', 'SMEMBERS', 'SMISMEMBER', 'SORT_RO', 'STRLEN', 'SUBSTR', 'SUNION', 'TS.GET', 'TS.INFO', 'TS.RANGE', 'TS.REVRANGE', 'TYPE', 'XLEN', 'XPENDING', 'XRANGE', 'XREAD', 'XREVRANGE', 'ZCARD', 'ZCOUNT', 'ZDIFF', 'ZINTER', 'ZINTERCARD', 'ZLEXCOUNT', 'ZMSCORE', 'ZRANGE', 'ZRANGEBYLEX', 'ZRANGEBYSCORE', 'ZRANK', 'ZREVRANGE', 'ZREVRANGEBYLEX', 'ZREVRANGEBYSCORE', 'ZREVRANK', 'ZSCORE', 'ZUNION'])[source]

Implementation of the Valkey protocol.

This abstract class provides a Python interface to all Valkey commands and an implementation of the Valkey protocol.

Pipelines derive from this, implementing how the commands are sent and received to the Valkey server. Based on configuration, an instance will either use a ConnectionPool, or Connection object to talk to valkey.

Parameters

        host (str) –

        port (int) –

        db (Union[str, int]) –

        password (Optional[str]) –

        socket_timeout (Optional[float]) –

        socket_connect_timeout (Optional[float]) –

        socket_keepalive (Optional[bool]) –

        socket_keepalive_options (Optional[Mapping[int, Union[int, bytes]]]) –

        connection_pool (Optional[ConnectionPool]) –

        unix_socket_path (Optional[str]) –

        encoding (str) –

        encoding_errors (str) –

        decode_responses (bool) –

        retry_on_timeout (bool) –

        retry_on_error (Optional[list]) –

        ssl (bool) –

        ssl_keyfile (Optional[str]) –

        ssl_certfile (Optional[str]) –

        ssl_cert_reqs (str) –

        ssl_ca_certs (Optional[str]) –

        ssl_ca_data (Optional[str]) –

        ssl_check_hostname (bool) –

        ssl_min_version (Optional[TLSVersion]) –

        ssl_ciphers (Optional[str]) –

        max_connections (Optional[int]) –

        single_connection_client (bool) –

        health_check_interval (int) –

        client_name (Optional[str]) –

        lib_name (Optional[str]) –

        lib_version (Optional[str]) –

        username (Optional[str]) –

        retry (Optional[Retry]) –

        auto_close_connection_pool (Optional[bool]) –

        credential_provider (Optional[CredentialProvider]) –

        protocol (Optional[int]) –

        cache_enabled (bool) –

        client_cache (Optional[AbstractCache]) –

        cache_max_size (int) –

        cache_ttl (int) –

        cache_policy (str) –

        cache_deny_list (List[str]) –

        cache_allow_list (List[str]) –

async aclose(close_connection_pool=None)[source]

    Closes Valkey client connection

    Parameters

        close_connection_pool (Optional[bool]) – decides whether to close the connection pool used
    Return type

        None

    by this Valkey client, overriding Valkey.auto_close_connection_pool. By default, let Valkey.auto_close_connection_pool decide whether to close the connection pool.

close(close_connection_pool=None)[source]

    Alias for aclose(), for backwards compatibility

    Parameters

        close_connection_pool (Optional[bool]) –
    Return type

        None

async execute_command(*args, **options)[source]

    Execute a command and return a parsed response

classmethod from_pool(connection_pool)[source]

    Return a Valkey client from the given connection pool. The Valkey client will take ownership of the connection pool and close it when the Valkey client is closed.

    Parameters

        connection_pool (ConnectionPool) –
    Return type

        Valkey

classmethod from_url(url, single_connection_client=False, auto_close_connection_pool=None, **kwargs)[source]

    Return a Valkey client object configured from the given URL

    For example:

    valkey://[[username]:[password]]@localhost:6379/0
    valkeys://[[username]:[password]]@localhost:6379/0
    unix://[username@]/path/to/socket.sock?db=0[&password=password]

    Three URL schemes are supported:

        valkey:// creates a TCP socket connection.

        valkeys:// creates a SSL wrapped TCP socket connection.

        unix://: creates a Unix Domain Socket connection.

    The username, password, hostname, path and all querystring values are passed through urllib.parse.unquote in order to replace any percent-encoded values with their corresponding characters.

    There are several ways to specify a database number. The first value found will be used:

        A db querystring option, e.g. valkey://localhost?db=0

        If using the valkey:// or valkeys:// schemes, the path argument

            of the url, e.g. valkey://localhost/0

        A db keyword argument to this function.

    If none of these options are specified, the default db=0 is used.

    All querystring options are cast to their appropriate Python types. Boolean arguments can be specified with string values “True”/”False” or “Yes”/”No”. Values that cannot be properly cast cause a ValueError to be raised. Once parsed, the querystring arguments and keyword arguments are passed to the ConnectionPool’s class initializer. In the case of conflicting arguments, querystring arguments always win.

    Parameters

            url (str) –

            single_connection_client (bool) –

            auto_close_connection_pool (Optional[bool]) –

            kwargs (Any) –

get_connection_kwargs()[source]

    Get the connection’s key-word arguments

get_encoder()[source]

    Get the connection pool’s encoder

load_external_module(funcname, func)[source]

    This function can be used to add externally defined valkey modules, and their namespaces to the valkey client.

    funcname - A string containing the name of the function to create func - The function, being added to this class.

    ex: Assume that one has a custom valkey module named foomod that creates command named ‘foo.dothing’ and ‘foo.anotherthing’ in valkey. To load function functions into this namespace:

    from valkey import Valkey from foomodule import F r = Valkey() r.load_external_module(“foo”, F) r.foo().dothing(‘your’, ‘arguments’)

    For a concrete example see the reimport of the redisjson module in tests/test_connection.py::test_loading_external_modules

lock(name, timeout=None, sleep=0.1, blocking=True, blocking_timeout=None, lock_class=None, thread_local=True)[source]

    Return a new Lock object using key name that mimics the behavior of threading.Lock.

    If specified, timeout indicates a maximum life for the lock. By default, it will remain locked until release() is called.

    sleep indicates the amount of time to sleep per loop iteration when the lock is in blocking mode and another client is currently holding the lock.

    blocking indicates whether calling acquire should block until the lock has been acquired or to fail immediately, causing acquire to return False and the lock not being acquired. Defaults to True. Note this value can be overridden by passing a blocking argument to acquire.

    blocking_timeout indicates the maximum amount of time in seconds to spend trying to acquire the lock. A value of None indicates continue trying forever. blocking_timeout can be specified as a float or integer, both representing the number of seconds to wait.

    lock_class forces the specified lock implementation. Note that the only lock class we implement is Lock (which is a Lua-based lock). So, it’s unlikely you’ll need this parameter, unless you have created your own custom lock class.

    thread_local indicates whether the lock token is placed in thread-local storage. By default, the token is placed in thread local storage so that a thread only sees its token, not a token set by another thread. Consider the following timeline:

        time: 0, thread-1 acquires my-lock, with a timeout of 5 seconds.

            thread-1 sets the token to “abc”
        time: 1, thread-2 blocks trying to acquire my-lock using the

            Lock instance.
        time: 5, thread-1 has not yet completed. valkey expires the lock

            key.
        time: 5, thread-2 acquired my-lock now that it’s available.

            thread-2 sets the token to “xyz”
        time: 6, thread-1 finishes its work and calls release(). if the

            token is not stored in thread local storage, then thread-1 would see the token value as “xyz” and would be able to successfully release the thread-2’s lock.

    In some use cases it’s necessary to disable thread local storage. For example, if you have code where one thread acquires a lock and passes that lock instance to a worker thread to release later. If thread local storage isn’t disabled in this case, the worker thread won’t see the token set by the thread that acquired the lock. Our assumption is that these cases aren’t common and as such default to using thread local storage.

    Parameters

            name (Union[bytes, str, memoryview]) –

            timeout (Optional[float]) –

            sleep (float) –

            blocking (bool) –

            blocking_timeout (Optional[float]) –

            lock_class (Optional[Type[Lock]]) –

            thread_local (bool) –

    Return type

        Lock

async parse_response(connection, command_name, **options)[source]

    Parses a response from the Valkey server

    Parameters

            connection (Connection) –

            command_name (Union[str, bytes]) –

pipeline(transaction=True, shard_hint=None)[source]

    Return a new pipeline object that can queue multiple commands for later execution. transaction indicates whether all commands should be executed atomically. Apart from making a group of operations atomic, pipelines are useful for reducing the back-and-forth overhead between the client and server.

    Parameters

            transaction (bool) –

            shard_hint (Optional[str]) –

    Return type

        Pipeline

pubsub(**kwargs)[source]

    Return a Publish/Subscribe object. With this object, you can subscribe to channels and listen for messages that get published to them.

    Parameters

        kwargs (Any) –
    Return type

        PubSub

set_response_callback(command, callback)[source]

    Set a custom Response Callback

    Parameters

            command (str) –

            callback (Union[ResponseCallbackProtocol, AsyncResponseCallbackProtocol]) –

async transaction(func, *watches, shard_hint=None, value_from_callable=False, watch_delay=None)[source]

        Convenience method for executing the callable func as a transaction while watching all keys specified in watches. The ‘func’ callable should expect a single argument which is a Pipeline object.

        Parameters

                func (Callable[[Pipeline], Union[Any, Awaitable[Any]]]) –

                watches (Union[bytes, str, memoryview]) –

                shard_hint (Optional[str]) –

                value_from_callable (bool) –

                watch_delay (Optional[float]) –

Async Cluster Client
ValkeyCluster (Async)
class valkey.asyncio.cluster.ValkeyCluster(host=None, port=6379, startup_nodes=None, require_full_coverage=True, read_from_replicas=False, dynamic_startup_nodes=True, reinitialize_steps=5, cluster_error_retry_attempts=3, connection_error_retry_attempts=3, max_connections=2147483648, db=0, path=None, credential_provider=None, username=None, password=None, client_name=None, lib_name='valkey-py', lib_version='99.99.99', encoding='utf-8', encoding_errors='strict', decode_responses=False, health_check_interval=0, socket_connect_timeout=None, socket_keepalive=False, socket_keepalive_options=None, socket_timeout=5, retry=None, retry_on_error=None, ssl=False, ssl_ca_certs=None, ssl_ca_data=None, ssl_cert_reqs='required', ssl_certfile=None, ssl_check_hostname=False, ssl_keyfile=None, ssl_min_version=None, ssl_ciphers=None, protocol=2, address_remap=None, cache_enabled=False, client_cache=None, cache_max_size=100, cache_ttl=0, cache_policy=EvictionPolicy.LRU, cache_deny_list=['BF.CARD', 'BF.DEBUG', 'BF.EXISTS', 'BF.INFO', 'BF.MEXISTS', 'BF.SCANDUMP', 'CF.COMPACT', 'CF.COUNT', 'CF.DEBUG', 'CF.EXISTS', 'CF.INFO', 'CF.MEXISTS', 'CF.SCANDUMP', 'CMS.INFO', 'CMS.QUERY', 'DUMP', 'EXPIRETIME', 'FT.AGGREGATE', 'FT.ALIASADD', 'FT.ALIASDEL', 'FT.ALIASUPDATE', 'FT.CURSOR', 'FT.EXPLAIN', 'FT.EXPLAINCLI', 'FT.GET', 'FT.INFO', 'FT.MGET', 'FT.PROFILE', 'FT.SEARCH', 'FT.SPELLCHECK', 'FT.SUGGET', 'FT.SUGLEN', 'FT.SYNDUMP', 'FT.TAGVALS', 'FT._ALIASADDIFNX', 'FT._ALIASDELIFX', 'HRANDFIELD', 'JSON.DEBUG', 'PEXPIRETIME', 'PFCOUNT', 'PTTL', 'SRANDMEMBER', 'TDIGEST.BYRANK', 'TDIGEST.BYREVRANK', 'TDIGEST.CDF', 'TDIGEST.INFO', 'TDIGEST.MAX', 'TDIGEST.MIN', 'TDIGEST.QUANTILE', 'TDIGEST.RANK', 'TDIGEST.REVRANK', 'TDIGEST.TRIMMED_MEAN', 'TOPK.INFO', 'TOPK.LIST', 'TOPK.QUERY', 'TOUCH', 'TTL'], cache_allow_list=['BITCOUNT', 'BITFIELD_RO', 'BITPOS', 'EXISTS', 'GEODIST', 'GEOHASH', 'GEOPOS', 'GEORADIUSBYMEMBER_RO', 'GEORADIUS_RO', 'GEOSEARCH', 'GET', 'GETBIT', 'GETRANGE', 'HEXISTS', 'HGET', 'HGETALL', 'HKEYS', 'HLEN', 'HMGET', 'HSTRLEN', 'HVALS', 'JSON.ARRINDEX', 'JSON.ARRLEN', 'JSON.GET', 'JSON.MGET', 'JSON.OBJKEYS', 'JSON.OBJLEN', 'JSON.RESP', 'JSON.STRLEN', 'JSON.TYPE', 'LCS', 'LINDEX', 'LLEN', 'LPOS', 'LRANGE', 'MGET', 'SCARD', 'SDIFF', 'SINTER', 'SINTERCARD', 'SISMEMBER', 'SMEMBERS', 'SMISMEMBER', 'SORT_RO', 'STRLEN', 'SUBSTR', 'SUNION', 'TS.GET', 'TS.INFO', 'TS.RANGE', 'TS.REVRANGE', 'TYPE', 'XLEN', 'XPENDING', 'XRANGE', 'XREAD', 'XREVRANGE', 'ZCARD', 'ZCOUNT', 'ZDIFF', 'ZINTER', 'ZINTERCARD', 'ZLEXCOUNT', 'ZMSCORE', 'ZRANGE', 'ZRANGEBYLEX', 'ZRANGEBYSCORE', 'ZRANK', 'ZREVRANGE', 'ZREVRANGEBYLEX', 'ZREVRANGEBYSCORE', 'ZREVRANK', 'ZSCORE', 'ZUNION'])[source]

Create a new ValkeyCluster client.

Pass one of parameters:

        host & port

        startup_nodes

Use await initialize() to find cluster nodes & create connections.
Use await close() to disconnect connections & close client.

Many commands support the target_nodes kwarg. It can be one of the NODE_FLAGS:

        PRIMARIES

        REPLICAS

        ALL_NODES

        RANDOM

        DEFAULT_NODE

Note: This client is not thread/process/fork safe.

Parameters

        host (Optional[str]) –
        Can be used to point to a startup node

        port (Union[str, int]) –
        Port used if host is provided

        startup_nodes (Optional[List[ClusterNode]]) –
        ClusterNode to used as a startup node

        require_full_coverage (bool) –
        When set to False: the client will not require a full coverage of the slots. However, if not all slots are covered, and at least one node has cluster-require-full-coverage set to yes, the server will throw a ClusterDownError for some key-based commands.
        When set to True: all slots must be covered to construct the cluster client. If not all slots are covered, ValkeyClusterException will be thrown.
        See: https://valkey.io/docs/manual/scaling/#valkey-cluster-configuration-parameters

        read_from_replicas (bool) –
        Enable read from replicas in READONLY mode. You can read possibly stale data. When set to true, read commands will be assigned between the primary and its replications in a Round-Robin manner.

        dynamic_startup_nodes (bool) –
        Set the ValkeyCluster’s startup nodes to all the discovered nodes. If true (default value), the cluster’s discovered nodes will be used to determine the cluster nodes-slots mapping in the next topology refresh. It will remove the initial passed startup nodes if their endpoints aren’t listed in the CLUSTER SLOTS output. If you use dynamic DNS endpoints for startup nodes but CLUSTER SLOTS lists specific IP addresses, it is best to set it to false.

        reinitialize_steps (int) –
        Specifies the number of MOVED errors that need to occur before reinitializing the whole cluster topology. If a MOVED error occurs and the cluster does not need to be reinitialized on this current error handling, only the MOVED slot will be patched with the redirected node. To reinitialize the cluster on every MOVED error, set reinitialize_steps to 1. To avoid reinitializing the cluster on moved errors, set reinitialize_steps to 0.

        cluster_error_retry_attempts (int) –
        Number of times to retry before raising an error when TimeoutError or ConnectionError or ClusterDownError are encountered

        connection_error_retry_attempts (int) –
        Number of times to retry before reinitializing when TimeoutError or ConnectionError are encountered. The default backoff strategy will be set if Retry object is not passed (see default_backoff in backoff.py). To change it, pass a custom Retry object using the “retry” keyword.

        max_connections (int) –
        Maximum number of connections per node. If there are no free connections & the maximum number of connections are already created, a MaxConnectionsError is raised. This error may be retried as defined by connection_error_retry_attempts

        address_remap (Optional[Callable[[Tuple[str, int]], Tuple[str, int]]]) –
        An optional callable which, when provided with an internal network address of a node, e.g. a (host, port) tuple, will return the address where the node is reachable. This can be used to map the addresses at which the nodes _think_ they are, to addresses at which a client may reach them, such as when they sit behind a proxy.

        db (Union[str, int]) –

        path (Optional[str]) –

        credential_provider (Optional[CredentialProvider]) –

        username (Optional[str]) –

        password (Optional[str]) –

        client_name (Optional[str]) –

        lib_name (Optional[str]) –

        lib_version (Optional[str]) –

        encoding (str) –

        encoding_errors (str) –

        decode_responses (bool) –

        health_check_interval (float) –

        socket_connect_timeout (Optional[float]) –

        socket_keepalive (bool) –

        socket_keepalive_options (Optional[Mapping[int, Union[int, bytes]]]) –

        socket_timeout (Optional[float]) –

        retry (Optional[Retry]) –

        retry_on_error (Optional[List[Type[Exception]]]) –

        ssl (bool) –

        ssl_ca_certs (Optional[str]) –

        ssl_ca_data (Optional[str]) –

        ssl_cert_reqs (str) –

        ssl_certfile (Optional[str]) –

        ssl_check_hostname (bool) –

        ssl_keyfile (Optional[str]) –

        ssl_min_version (Optional[TLSVersion]) –

        ssl_ciphers (Optional[str]) –

        protocol (Optional[int]) –

        cache_enabled (bool) –

        client_cache (Optional[AbstractCache]) –

        cache_max_size (int) –

        cache_ttl (int) –

        cache_policy (str) –

        cache_deny_list (List[str]) –

        cache_allow_list (List[str]) –

Rest of the arguments will be passed to the Connection instances when created

Raises

    ValkeyClusterException –

    if any arguments are invalid or unknown. Eg:

        db != 0 or None

        path argument for unix socket connection

        none of the host/port & startup_nodes were provided

Parameters

        host (Optional[str]) –

        port (Union[str, int]) –

        startup_nodes (Optional[List[ClusterNode]]) –

        require_full_coverage (bool) –

        read_from_replicas (bool) –

        dynamic_startup_nodes (bool) –

        reinitialize_steps (int) –

        cluster_error_retry_attempts (int) –

        connection_error_retry_attempts (int) –

        max_connections (int) –

        db (Union[str, int]) –

        path (Optional[str]) –

        credential_provider (Optional[CredentialProvider]) –

        username (Optional[str]) –

        password (Optional[str]) –

        client_name (Optional[str]) –

        lib_name (Optional[str]) –

        lib_version (Optional[str]) –

        encoding (str) –

        encoding_errors (str) –

        decode_responses (bool) –

        health_check_interval (float) –

        socket_connect_timeout (Optional[float]) –

        socket_keepalive (bool) –

        socket_keepalive_options (Optional[Mapping[int, Union[int, bytes]]]) –

        socket_timeout (Optional[float]) –

        retry (Optional[Retry]) –

        retry_on_error (Optional[List[Type[Exception]]]) –

        ssl (bool) –

        ssl_ca_certs (Optional[str]) –

        ssl_ca_data (Optional[str]) –

        ssl_cert_reqs (str) –

        ssl_certfile (Optional[str]) –

        ssl_check_hostname (bool) –

        ssl_keyfile (Optional[str]) –

        ssl_min_version (Optional[TLSVersion]) –

        ssl_ciphers (Optional[str]) –

        protocol (Optional[int]) –

        address_remap (Optional[Callable[[Tuple[str, int]], Tuple[str, int]]]) –

        cache_enabled (bool) –

        client_cache (Optional[AbstractCache]) –

        cache_max_size (int) –

        cache_ttl (int) –

        cache_policy (str) –

        cache_deny_list (List[str]) –

        cache_allow_list (List[str]) –

classmethod from_url(url, **kwargs)[source]

    Return a Valkey client object configured from the given URL.

    For example:

    valkey://[[username]:[password]]@localhost:6379/0
    valkeys://[[username]:[password]]@localhost:6379/0

    Three URL schemes are supported:

        valkey:// creates a TCP socket connection.

        valkeys:// creates a SSL wrapped TCP socket connection.

    The username, password, hostname, path and all querystring values are passed through urllib.parse.unquote in order to replace any percent-encoded values with their corresponding characters.

    All querystring options are cast to their appropriate Python types. Boolean arguments can be specified with string values “True”/”False” or “Yes”/”No”. Values that cannot be properly cast cause a ValueError to be raised. Once parsed, the querystring arguments and keyword arguments are passed to Connection when created. In the case of conflicting arguments, querystring arguments are used.

    Parameters

            url (str) –

            kwargs (Any) –

    Return type

        ValkeyCluster

async initialize()[source]

    Get all nodes from startup nodes & creates connections if not initialized.

    Return type

        ValkeyCluster

async aclose()[source]

    Close all connections & client if initialized.

    Return type

        None

close()[source]

    alias for aclose() for backwards compatibility

    Return type

        None

get_nodes()[source]

    Get all nodes of the cluster.

    Return type

        List[ClusterNode]

get_primaries()[source]

    Get the primary nodes of the cluster.

    Return type

        List[ClusterNode]

get_replicas()[source]

    Get the replica nodes of the cluster.

    Return type

        List[ClusterNode]

get_random_node()[source]

    Get a random node of the cluster.

    Return type

        ClusterNode

get_default_node()[source]

    Get the default node of the client.

    Return type

        ClusterNode

set_default_node(node)[source]

    Set the default node of the client.

    Raises

        DataError – if None is passed or node does not exist in cluster.
    Parameters

        node (ClusterNode) –
    Return type

        None

get_node(host=None, port=None, node_name=None)[source]

    Get node by (host, port) or node_name.

    Parameters

            host (Optional[str]) –

            port (Optional[int]) –

            node_name (Optional[str]) –

    Return type

        Optional[ClusterNode]

get_node_from_key(key, replica=False)[source]

    Get the cluster node corresponding to the provided key.

    Parameters

            key (str) –

            replica (bool) –
            Indicates if a replica should be returned
            None will returned if no replica holds this key

    Raises

        SlotNotCoveredError – if the key is not covered by any slot.
    Return type

        Optional[ClusterNode]

keyslot(key)[source]

    Find the keyslot for a given key.

    See: https://valkey.io/docs/manual/scaling/#valkey-cluster-data-sharding

    Parameters

        key (Union[bytes, memoryview, str, int, float]) –
    Return type

        int

get_encoder()[source]

    Get the encoder object of the client.

    Return type

        Encoder

get_connection_kwargs()[source]

    Get the kwargs passed to Connection.

    Return type

        Dict[str, Optional[Any]]

set_response_callback(command, callback)[source]

    Set a custom response callback.

    Parameters

            command (str) –

            callback (Union[ResponseCallbackProtocol, AsyncResponseCallbackProtocol]) –

    Return type

        None

async execute_command(*args, **kwargs)[source]

    Execute a raw command on the appropriate cluster node or target_nodes.

    It will retry the command as specified by cluster_error_retry_attempts & then raise an exception.

    Parameters

            args (Union[bytes, memoryview, str, int, float]) –
            Raw command args

            kwargs (Any) –

                target_nodes: NODE_FLAGS or ClusterNode or List[ClusterNode] or Dict[Any, ClusterNode]

                Rest of the kwargs are passed to the Valkey connection

    Raises

        ValkeyClusterException – if target_nodes is not provided & the command can’t be mapped to a slot
    Return type

        Any

pipeline(transaction=None, shard_hint=None)[source]

    Create & return a new ClusterPipeline object.

    Cluster implementation of pipeline does not support transaction or shard_hint.

    Raises

        ValkeyClusterException – if transaction or shard_hint are truthy values
    Parameters

            transaction (Union[None, Any]) –

            shard_hint (Union[None, Any]) –

    Return type

        ClusterPipeline

lock(name, timeout=None, sleep=0.1, blocking=True, blocking_timeout=None, lock_class=None, thread_local=True)[source]

        Return a new Lock object using key name that mimics the behavior of threading.Lock.

        If specified, timeout indicates a maximum life for the lock. By default, it will remain locked until release() is called.

        sleep indicates the amount of time to sleep per loop iteration when the lock is in blocking mode and another client is currently holding the lock.

        blocking indicates whether calling acquire should block until the lock has been acquired or to fail immediately, causing acquire to return False and the lock not being acquired. Defaults to True. Note this value can be overridden by passing a blocking argument to acquire.

        blocking_timeout indicates the maximum amount of time in seconds to spend trying to acquire the lock. A value of None indicates continue trying forever. blocking_timeout can be specified as a float or integer, both representing the number of seconds to wait.

        lock_class forces the specified lock implementation. Note that the only lock class we implement is Lock (which is a Lua-based lock). So, it’s unlikely you’ll need this parameter, unless you have created your own custom lock class.

        thread_local indicates whether the lock token is placed in thread-local storage. By default, the token is placed in thread local storage so that a thread only sees its token, not a token set by another thread. Consider the following timeline:

            time: 0, thread-1 acquires my-lock, with a timeout of 5 seconds.

                thread-1 sets the token to “abc”
            time: 1, thread-2 blocks trying to acquire my-lock using the

                Lock instance.
            time: 5, thread-1 has not yet completed. valkey expires the lock

                key.
            time: 5, thread-2 acquired my-lock now that it’s available.

                thread-2 sets the token to “xyz”
            time: 6, thread-1 finishes its work and calls release(). if the

                token is not stored in thread local storage, then thread-1 would see the token value as “xyz” and would be able to successfully release the thread-2’s lock.

        In some use cases it’s necessary to disable thread local storage. For example, if you have code where one thread acquires a lock and passes that lock instance to a worker thread to release later. If thread local storage isn’t disabled in this case, the worker thread won’t see the token set by the thread that acquired the lock. Our assumption is that these cases aren’t common and as such default to using thread local storage.

        Parameters

                name (Union[bytes, str, memoryview]) –

                timeout (Optional[float]) –

                sleep (float) –

                blocking (bool) –

                blocking_timeout (Optional[float]) –

                lock_class (Optional[Type[Lock]]) –

                thread_local (bool) –

        Return type

            Lock

ClusterNode (Async)
class valkey.asyncio.cluster.ClusterNode(host, port, server_type=None, *, max_connections=2147483648, connection_class=<class 'valkey.asyncio.connection.Connection'>, **connection_kwargs)[source]

    Create a new ClusterNode.

    Each ClusterNode manages multiple Connection objects for the (host, port).

    Parameters

            host (str) –

            port (Union[str, int]) –

            server_type (Optional[str]) –

            max_connections (int) –

            connection_class (Type[Connection]) –

            connection_kwargs (Any) –

ClusterPipeline (Async)
class valkey.asyncio.cluster.ClusterPipeline(client)[source]

Create a new ClusterPipeline object.

Usage:

result = await (
    rc.pipeline()
    .set("A", 1)
    .get("A")
    .hset("K", "F", "V")
    .hgetall("K")
    .mset_nonatomic({"A": 2, "B": 3})
    .get("A")
    .get("B")
    .delete("A", "B", "K")
    .execute()
)
# result = [True, "1", 1, {"F": "V"}, True, True, "2", "3", 1, 1, 1]

Note: For commands DELETE, EXISTS, TOUCH, UNLINK, mset_nonatomic, which are split across multiple nodes, you’ll get multiple results for them in the array.

Retryable errors:

        ClusterDownError

        ConnectionError

        TimeoutError

Redirection errors:

        TryAgainError

        MovedError

        AskError

Parameters

    client (ValkeyCluster) –
    Existing ValkeyCluster client

execute_command(*args, **kwargs)[source]

    Append a raw command to the pipeline.

    Parameters

            args (Union[bytes, str, memoryview, int, float]) –
            Raw command args

            kwargs (Any) –

                target_nodes: NODE_FLAGS or ClusterNode or List[ClusterNode] or Dict[Any, ClusterNode]

                Rest of the kwargs are passed to the Valkey connection

    Return type

        ClusterPipeline

async execute(raise_on_error=True, allow_redirections=True)[source]

        Execute the pipeline.

        It will retry the commands as specified by cluster_error_retry_attempts & then raise an exception.

        Parameters

                raise_on_error (bool) –
                Raise the first error if there are any errors

                allow_redirections (bool) –
                Whether to retry each failed command individually in case of redirection errors

        Raises

            ValkeyClusterException – if target_nodes is not provided & the command can’t be mapped to a slot
        Return type

            List[Any]

Connection

See complete example: here
Connection
class valkey.connection.Connection(host='localhost', port=6379, socket_keepalive=False, socket_keepalive_options=None, socket_type=0, **kwargs)[source]

    Manages TCP communication to and from a Valkey server

Connection (Async)
class valkey.asyncio.connection.Connection(*, host='localhost', port=6379, socket_keepalive=False, socket_keepalive_options=None, socket_type=0, **kwargs)[source]

    Manages TCP communication to and from a Valkey server

    Parameters

            host (str) –

            port (Union[str, int]) –

            socket_keepalive (bool) –

            socket_keepalive_options (Optional[Mapping[int, Union[int, bytes]]]) –

            socket_type (int) –

Connection Pools

See complete example: here
ConnectionPool
class valkey.connection.ConnectionPool(connection_class=<class 'valkey.connection.Connection'>, max_connections=None, **connection_kwargs)[source]

Create a connection pool. If max_connections is set, then this object raises ConnectionError when the pool’s limit is reached.

By default, TCP connections are created unless connection_class is specified. Use class:.UnixDomainSocketConnection for unix sockets.

Any additional keyword arguments are passed to the constructor of connection_class.

Parameters

    max_connections (Optional[int]) –

close()[source]

    Close the pool, disconnecting all connections

    Return type

        None

disconnect(inuse_connections=True)[source]

    Disconnects connections in the pool

    If inuse_connections is True, disconnect connections that are current in use, potentially by other threads. Otherwise only disconnect connections that are idle in the pool.

    Parameters

        inuse_connections (bool) –
    Return type

        None

classmethod from_url(url, **kwargs)[source]

    Return a connection pool configured from the given URL.

    For example:

    valkey://[[username]:[password]]@localhost:6379/0
    valkeys://[[username]:[password]]@localhost:6379/0
    unix://[username@]/path/to/socket.sock?db=0[&password=password]

    Three URL schemes are supported:

        valkey:// creates a TCP socket connection.

        valkeys:// creates a SSL wrapped TCP socket connection.

        unix://: creates a Unix Domain Socket connection.

    The username, password, hostname, path and all querystring values are passed through urllib.parse.unquote in order to replace any percent-encoded values with their corresponding characters.

    There are several ways to specify a database number. The first value found will be used:

            A db querystring option, e.g. valkey://localhost?db=0

            If using the valkey:// or valkeys:// schemes, the path argument of the url, e.g. valkey://localhost/0

            A db keyword argument to this function.

    If none of these options are specified, the default db=0 is used.

    All querystring options are cast to their appropriate Python types. Boolean arguments can be specified with string values “True”/”False” or “Yes”/”No”. Values that cannot be properly cast cause a ValueError to be raised. Once parsed, the querystring arguments and keyword arguments are passed to the ConnectionPool’s class initializer. In the case of conflicting arguments, querystring arguments always win.

get_connection(command_name, *keys, **options)[source]

    Get a connection from the pool

    Parameters

        command_name (str) –
    Return type

        Connection

get_encoder()[source]

    Return an encoder based on encoding settings

    Return type

        Encoder

make_connection()[source]

    Create a new connection

    Return type

        Connection

release(connection)[source]

        Releases the connection back to the pool

        Parameters

            connection (Connection) –
        Return type

            None

ConnectionPool (Async)
class valkey.asyncio.connection.ConnectionPool(connection_class=<class 'valkey.asyncio.connection.Connection'>, max_connections=None, **connection_kwargs)[source]

Create a connection pool. If max_connections is set, then this object raises ConnectionError when the pool’s limit is reached.

By default, TCP connections are created unless connection_class is specified. Use UnixDomainSocketConnection for unix sockets.

Any additional keyword arguments are passed to the constructor of connection_class.

Parameters

        connection_class (Type[AbstractConnection]) –

        max_connections (Optional[int]) –

async aclose()[source]

    Close the pool, disconnecting all connections

    Return type

        None

can_get_connection()[source]

    Return True if a connection can be retrieved from the pool.

    Return type

        bool

async disconnect(inuse_connections=True)[source]

    Disconnects connections in the pool

    If inuse_connections is True, disconnect connections that are current in use, potentially by other tasks. Otherwise only disconnect connections that are idle in the pool.

    Parameters

        inuse_connections (bool) –

async ensure_connection(connection)[source]

    Ensure that the connection object is connected and valid

    Parameters

        connection (AbstractConnection) –

classmethod from_url(url, **kwargs)[source]

    Return a connection pool configured from the given URL.

    For example:

    valkey://[[username]:[password]]@localhost:6379/0
    valkeys://[[username]:[password]]@localhost:6379/0
    unix://[username@]/path/to/socket.sock?db=0[&password=password]

    Three URL schemes are supported:

        valkey:// creates a TCP socket connection.

        valkeys:// creates a SSL wrapped TCP socket connection.

        unix://: creates a Unix Domain Socket connection.

    The username, password, hostname, path and all querystring values are passed through urllib.parse.unquote in order to replace any percent-encoded values with their corresponding characters.

    There are several ways to specify a database number. The first value found will be used:

        A db querystring option, e.g. valkey://localhost?db=0

        If using the valkey:// or valkeys:// schemes, the path argument

            of the url, e.g. valkey://localhost/0

        A db keyword argument to this function.

    If none of these options are specified, the default db=0 is used.

    All querystring options are cast to their appropriate Python types. Boolean arguments can be specified with string values “True”/”False” or “Yes”/”No”. Values that cannot be properly cast cause a ValueError to be raised. Once parsed, the querystring arguments and keyword arguments are passed to the ConnectionPool’s class initializer. In the case of conflicting arguments, querystring arguments always win.

    Parameters

        url (str) –
    Return type

        _CP

get_available_connection()[source]

    Get a connection from the pool, without making sure it is connected

async get_connection(command_name, *keys, **options)[source]

    Get a connected connection from the pool

get_encoder()[source]

    Return an encoder based on encoding settings

make_connection()[source]

    Create a new connection. Can be overridden by child classes.

async release(connection)[source]

    Releases the connection back to the pool

    Parameters

        connection (AbstractConnection) –

