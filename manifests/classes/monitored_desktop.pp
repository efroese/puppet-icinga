# $Id$

class nagios::monitored::desktop inherits nagios::monitored::common {
# define this host for nagios
  nagios2_host { $fqdn:
    hostgroups => "${domain},${operatingsystem},${virtual}",
	       notification_options => "n",
	       notification_period => "workhours",
  }
  nagios2_nsca_service { "${fqdn}_diskspace":
    service_description => "DISKUSAGE",
			notification_period => "workhours",
			notification_options => "n",
    ensure => "absent",
  }
  nagios2_nsca_service { "${fqdn}_load":
    service_description => "Load average",
			notification_period => "workhours",
			notification_options => "w,c,u",
  ensure => "absent",
  }
  }
