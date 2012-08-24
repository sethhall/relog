

## Set ElasticSearch as the default output.
redef Log::default_writer = Log::WRITER_ELASTICSEARCH;

## Set a reasonable rotation interval.
redef Log::default_rotation_interval = 3hr;

## Reconfigure the Input framework to ignore types that are unsupported for reading.
redef Input::accept_unsupported_types = T;
