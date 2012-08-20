##! This script is for reading in old Bro logs and sending them to a different
##! output.  It's mainly focused around reading Bro ascii logs and sending them
##! to ElasticSearch right now.
##!
##! This script is not intended to be run with any traffic because it will
##! shutdown Bro once the file has finished being read regardless of the 
##! status of Bro seeing network traffic.

@load frameworks/communication/listen

redef Log::default_writer = Log::WRITER_ELASTICSEARCH;
redef Log::default_rotation_interval = 3hr;

module ReLog;

export {
	## Use this table to create an association between a file name
	## on disk and a Log::ID
	const logs: table[string] of Log::ID &redef;
}


global last_record = current_time();

# This loop is used to shutdown Bro when no more logs are being written.
event watcher_loop()
	{
	if ( current_time() - last_record > 1secs )
		terminate();
	schedule 1sec { watcher_loop() };
	}

event log_record_ev(desc: Input::EventDescription, tpe: Input::Event, rec: any)
	{
	Log::write(logs[desc$source], rec);
	last_record = current_time();
	}

event bro_init() &priority=-5
	{
	if ( |logs| == 0 )
		{
		event reporter_error(current_time(), "ReLog loaded but not configured.  Shutting down.", "");
		terminate();
		return;
		}
	if ( reading_live_traffic() || reading_traces() )
		{
		event reporter_error(current_time(), "ReLog loaded and Bro reading traffic.  Unexpected results ahead so shutting down.", "");
		terminate();
		return;
		}


	for ( log_file in logs )
		{
		if ( logs[log_file] in Log::active_streams )
			Input::add_event([$source=log_file, 
			                  $name=log_file, 
			                  $fields=Log::active_streams[logs[log_file]]$columns,
			                  $ev=log_record_ev]);
		}
	event watcher_loop();
	}