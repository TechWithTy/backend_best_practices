valkey-py

The Python interface to the Valkey key-value store.

CI docs MIT licensed pypi pre-release codecov

Installation | Usage | Documentation | Advanced Topics | Contributing
Installation

Start a valkey via docker:

docker run -p 6379:6379 -it valkey/valkey:latest

To install valkey-py, simply:

$ pip install valkey

For faster performance, install valkey with libvalkey support, this provides a compiled response parser, and for most cases requires zero code changes. By default, if libvalkey >= 2.3.2 is available, valkey-py will attempt to use it for response parsing.

$ pip install "valkey[libvalkey]"

Usage
Basic Example

> > > import valkey
> > > r = valkey.Valkey(host='localhost', port=6379, db=0)
> > > r.set('foo', 'bar')
> > > True
> > > r.get('foo')
> > > b'bar'

The above code connects to localhost on port 6379, sets a value in Redis, and retrieves it. All responses are returned as bytes in Python, to receive decoded strings, set decode_responses=True. For this, and more connection options, see these examples.
Migration from redis-py

You are encouraged to use the new class names, but to allow for a smooth transition alias are available:

> > > import valkey as redis
> > > r = redis.Redis(host='localhost', port=6379, db=0)
> > > r.set('foo', 'bar')
> > > True
> > > r.get('foo')
> > > b'bar'

RESP3 Support

To enable support for RESP3 change your connection object to include protocol=3

> > > import valkey
> > > r = valkey.Valkey(host='localhost', port=6379, db=0, protocol=3)

Connection Pools

By default, valkey-py uses a connection pool to manage connections. Each instance of a Valkey class receives its own connection pool. You can however define your own valkey.ConnectionPool.

> > > pool = valkey.ConnectionPool(host='localhost', port=6379, db=0)
> > > r = valkey.Valkey(connection_pool=pool)

Alternatively, you might want to look at Async connections, or Cluster connections, or even Async Cluster connections.
Valkey Commands

There is built-in support for all of the out-of-the-box Valkey commands. They are exposed using the raw Redis command names (HSET, HGETALL, etc.) except where a word (i.e. del) is reserved by the language. The complete set of commands can be found here, or the documentation.
Documentation

Check out the documentation
Advanced Topics

The official Valkey command documentation does a great job of explaining each command in detail. valkey-py attempts to adhere to the official command syntax. There are a few exceptions:

    MULTI/EXEC: These are implemented as part of the Pipeline class. The pipeline is wrapped with the MULTI and EXEC statements by default when it is executed, which can be disabled by specifying transaction=False. See more about Pipelines below.

    SUBSCRIBE/LISTEN: Similar to pipelines, PubSub is implemented as a separate class as it places the underlying connection in a state where it can't execute non-pubsub commands. Calling the pubsub method from the Valkey client will return a PubSub instance where you can subscribe to channels and listen for messages. You can only call PUBLISH from the Valkey client (see this comment on issue #151 for details).

For more details, please see the documentation on advanced topics page.
Pipelines

The following is a basic example of a Valkey pipeline, a method to optimize round-trip calls, by batching Valkey commands, and receiving their results as a list.

> > > pipe = r.pipeline()
> > > pipe.set('foo', 5)
> > > pipe.set('bar', 18.5)
> > > pipe.set('blee', "hello world!")
> > > pipe.execute()
> > > [True, True, True]

PubSub

The following example shows how to utilize Valkey Pub/Sub to subscribe to specific channels.

> > > r = valkey.Valkey(...)
> > > p = r.pubsub()
> > > p.subscribe('my-first-channel', 'my-second-channel', ...)
> > > p.get_message()
> > > {'pattern': None, 'type': 'subscribe', 'channel': b'my-second-channel', 'data': 1}

Author

valkey-py can be found here, or downloaded from pypi. It was created as a fork of redis-py

Special thanks to:

    Andy McCurdy (sedrik@gmail.com) the original author of redis-py.
    Ludovico Magnocavallo, author of the original Python Redis client, from which some of the socket code is still used.
    Alexander Solovyov for ideas on the generic response callback system.
    Paul Hubbard for initial packaging support in redis-py.
