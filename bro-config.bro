

## Set ElasticSearch as the default output.
redef Log::default_writer = Log::WRITER_ELASTICSEARCH;

## Set a reasonable rotation interval.
# Set the rotation interval to zero to disable rotation because logs 
## end up in the incorrect index if rotation is enabled since network_time()
## is driven by the wall clock.
redef Log::default_rotation_interval = 0hr;

## Reconfigure the Input framework to ignore types that are unsupported for reading.
redef Input::accept_unsupported_types = T;
