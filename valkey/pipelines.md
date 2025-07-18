Pipelines

Script objects can also be used in pipelines. The pipeline instance should be passed as the client argument when calling the script. Care is taken to ensure that the script is registered in Valkey’s script cache just prior to pipeline execution.

pipe = r.pipeline()

pipe.set('foo', 5)

multiply(keys=['foo'], args=[5], client=pipe)

pipe.execute()
[True, 25]

