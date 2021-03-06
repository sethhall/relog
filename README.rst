Bro ReLog
=========

A Module for Bro to read ASCII logs and send them to some other writer.  By default logs are sent to the ElasticSearch writer with this script.  This is a convenient and easy way to import old ASCII logs into ElasticSearch for use with `Brownian <https://github.com/grigorescu/Brownian>`_.

.. note::

	This script will only work with Bro 2.1+.

Installation
------------

This script is only meant for manual usage and if it's loaded when reading traffic or not configured, Bro will send a message to the reporter framework and terminate.

::

	cd <prefix>/share/bro/site/
	git clone git://github.com/sethhall/relog.git

Configuration
-------------

You need to tell the script which file names you would like to read from and what the Log::ID is for that log.

Example
~~~~~~~

If you just have a log or two you'd like to import, you can run Bro directly at the command line::

	bro relog 'ReLog::logs += { ["/tmp/conn.log"] = Conn::LOG,
	                            ["/tmp/dns.log"] = DNS::LOG }'

If you have more scripts and you need define the files to read in a script you will use the "redef" syntax like this::

	@load relog
	redef ReLog::logs += { ["/tmp/conn.log"] = Conn::LOG,
	                        ["/tmp/dns.log"] = DNS::LOG };

.. note::

	If you loaded scripts that included extra fields in your logs, you will need to be sure and load those scripts when relogging.  This can typically be dealt with by just loading your site/local.bro script.

.. note::

	Remember to set the location for your ElasticSearch server if it's not the default "localhost".  redef LogElasticSearch::server_host = "other-host";

.. note::

	At this time, this script unfortunately doesn't support gzipped logs.

