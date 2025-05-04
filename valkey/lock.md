Lock
class valkey.lock.Lock(valkey, name, timeout=None, sleep=0.1, blocking=True, blocking_timeout=None, thread_local=True)[source]

A shared, distributed Lock. Using Valkey for locking allows the Lock to be shared across processes and/or machines.

It’s left to the user to resolve deadlock issues and make sure multiple clients play nicely together.

Parameters

        name (str) –

        timeout (Optional[Union[int, float]]) –

        sleep (Union[int, float]) –

        blocking (bool) –

        blocking_timeout (Optional[Union[int, float]]) –

        thread_local (bool) –

acquire(sleep=None, blocking=None, blocking_timeout=None, token=None)[source]

    Use Valkey to hold a shared, distributed lock named name. Returns True once the lock is acquired.

    If blocking is False, always return immediately. If the lock was acquired, return True, otherwise return False.

    blocking_timeout specifies the maximum number of seconds to wait trying to acquire the lock.

    token specifies the token value to be used. If provided, token must be a bytes object or a string that can be encoded to a bytes object with the default encoding. If a token isn’t specified, a UUID will be generated.

    Parameters

            sleep (Optional[Union[int, float]]) –

            blocking (Optional[bool]) –

            blocking_timeout (Optional[Union[int, float]]) –

            token (Optional[str]) –

extend(additional_time, replace_ttl=False)[source]

    Adds more time to an already acquired lock.

    additional_time can be specified as an integer or a float, both representing the number of seconds to add.

    replace_ttl if False (the default), add additional_time to the lock’s existing ttl. If True, replace the lock’s ttl with additional_time.

    Parameters

            additional_time (int) –

            replace_ttl (bool) –

    Return type

        bool

locked()[source]

    Returns True if this key is locked by any process, otherwise False.

    Return type

        bool

owned()[source]

    Returns True if this key is locked by this lock, otherwise False.

    Return type

        bool

reacquire()[source]

    Resets a TTL of an already acquired lock back to a timeout value.

    Return type

        bool

release()[source]

    Releases the already acquired lock

    Return type

        None

