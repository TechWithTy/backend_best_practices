Backoff
class valkey.backoff.AbstractBackoff[source]

Backoff interface

abstract compute(failures)[source]

    Compute backoff in seconds upon failure

    Parameters

        failures (int) –
    Return type

        float

reset()[source]

        Reset internal state before an operation. reset is called once at the beginning of every call to Retry.call_with_retry

class valkey.backoff.ConstantBackoff(backoff)[source]

Constant backoff upon failure

Parameters

    backoff (float) –

compute(failures)[source]

        Compute backoff in seconds upon failure

        Parameters

            failures (int) –
        Return type

            float

class valkey.backoff.DecorrelatedJitterBackoff(cap=0.512, base=0.008)[source]

Decorrelated jitter backoff upon failure

Parameters

        cap (float) –

        base (float) –

compute(failures)[source]

    Compute backoff in seconds upon failure

    Parameters

        failures (int) –
    Return type

        float

reset()[source]

        Reset internal state before an operation. reset is called once at the beginning of every call to Retry.call_with_retry

        Return type

            None

class valkey.backoff.EqualJitterBackoff(cap=0.512, base=0.008)[source]

Equal jitter backoff upon failure

Parameters

        cap (float) –

        base (float) –

compute(failures)[source]

        Compute backoff in seconds upon failure

        Parameters

            failures (int) –
        Return type

            float

class valkey.backoff.ExponentialBackoff(cap=0.512, base=0.008)[source]

Exponential backoff upon failure

Parameters

        cap (float) –

        base (float) –

compute(failures)[source]

        Compute backoff in seconds upon failure

        Parameters

            failures (int) –
        Return type

            float

class valkey.backoff.FullJitterBackoff(cap=0.512, base=0.008)[source]

Full jitter backoff upon failure

Parameters

        cap (float) –

        base (float) –

compute(failures)[source]

        Compute backoff in seconds upon failure

        Parameters

            failures (int) –
        Return type

            float

class valkey.backoff.NoBackoff[source]

No backoff upon failure