Browse this documentaiton - https://valkey-py.readthedocs.io/en/latest/examples.html

    Connection Examples
        Connecting to a default Valkey instance, running locally.
            By default Valkey return binary responses, to decode them use decode_responses=True
            By default this library uses the RESP 2 protocol. To enable RESP3, set protocol=3.
        Connecting to a valkey instance, specifying a host and port with credentials.
        Connecting to a valkey instance with username and password credential provider
        Connecting to a valkey instance with standard credential provider
        Connecting to a valkey instance first with an initial credential set and then calling the credential provider
        Connecting to a valkey instance with AWS Secrets Manager credential provider.
        Connecting to a valkey instance with ElastiCache IAM credential provider.
        Connecting to Valkey instances by specifying a URL scheme.
        Connecting to Valkey instances by specifying a URL scheme and the RESP3 protocol.
        Connecting to a Sentinel instance
    SSL Connection Examples
        Connecting to a Valkey instance via SSL
        Connecting to a Valkey instance via a URL string
        Connecting to a Valkey instance using a ConnectionPool
        Connecting to a Valkey instance via SSL, while specifying a minimum TLS version
        Connecting to a Valkey instance via SSL, while specifying a self-signed SSL CA certificate
        Connecting to a Valkey instance via SSL, and validate the OCSP status of the certificate
        Connect to a Valkey instance via SSL, and validate OCSP-stapled certificates
    Asyncio Examples
        Connecting and Disconnecting
        Transactions (Multi/Exec)
        Pub/Sub Mode
        Sentinel Client
        Connecting to Valkey instances by specifying a URL scheme.
    Indexing / querying JSON documents
        Adding a JSON document to an index
        Searching
            Simple search
            Filtering search results
            Paginating and Ordering search Results
            Counting the total number of Items
            Projecting using JSON Path expressions
        Aggregation
            Count the total number of Items
    Basic set and get operations
        Start off by connecting to the valkey server
    Vector Similarity
        Index Creation
        Adding Vectors to Valkey
        Searching
            KNN Queries
            Range Queries
            Hybrid Queries
        Vector Creation and Storage Examples
            OpenAI Embeddings
            Search with OpenAI Embeddings
            Cohere Embeddings
            Search with Cohere Embeddings
    Pipeline examples
        Checking that Valkey is running
        Simple example
            Creating a pipeline instance
            Adding commands to the pipeline
            Executing the pipeline
        Chained call
        Performance comparison
            Without pipeline
            With pipeline
    Timeseries
        Health check
        Simple example
            Create a timeseries
            Add samples to the timeseries
            Get the last sample
            Get samples between two timestamps
            Delete samples between two timestamps
        Multiple timeseries with labels
            Add samples to multiple timeseries
            Add samples with labels
            Get the last sample matching specific label
        Retention period
        Specify duplicate policies
        Using Valkey TSDB to keep track of a value
        How to execute multi-key commands on Open Source Valkey Cluster
    OpenTelemetry Python API
        Install OpenTelemetry
            Configure OpenTelemetry with console exporter
            Create a span using the tracer
            Record attributes
            Change the span kind
            Exceptions are automatically recorded
            Use nested blocks to create child spans
