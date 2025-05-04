Cluster Mode

Cluster mode has limited support for lua scripting.

The following commands are supported, with caveats:

    EVAL and EVALSHA: The command is sent to the relevant node, depending on the keys (i.e., in EVAL "<script>" num_keys key_1 ... key_n ...). The keys must all be on the same node. If the script requires 0 keys, the command is sent to a random (primary) node.

    SCRIPT EXISTS: The command is sent to all primaries. The result is a list of booleans corresponding to the input SHA hashes. Each boolean is an AND of “does the script exist on each node?”. In other words, each boolean is True iff the script exists on all nodes.

    SCRIPT FLUSH: The command is sent to all primaries. The result is a bool AND over all nodes’ responses.

    SCRIPT LOAD: The command is sent to all primaries. The result is the SHA1 digest.

The following commands are not supported:

    EVAL_RO

    EVALSHA_RO

Using scripting within pipelines in cluster mode is not supported.