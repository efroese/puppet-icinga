# $Id$

class nagios::monitored::common {
  nagios2_service { "${fqdn}_ssh":
    service_description => "SSH",
			check_command => "check_ssh",
			notification_period => "workhours",
  }
  nagios2_service { "${fqdn}_ping":
    service_description => "PING",
			check_command => "check_ping!125.0,20%!500.0,60%",
			dependent_service_description => "",
    normal_check_interval => "10",
  }
  case $kernel {
    "Linux": {
      $apt_present = "present"
    }
    default: {
	       $apt_present = "absent"
	     }
  }
  nagios2_nsca_service { "${fqdn}_packages":
    service_description => "Pending packages",
			notification_period => "workhours",
			notification_options => "n",
			ensure => absent,
  }

  nagios2_nrpe_service { "${fqdn}_nrpe_apt":
    command_name => "check_apt",
		 command_line => "${nagios::monitored::server::nrpe::nagiosplugins}/check_apt",
		 service_description => "APT",
		 normal_check_interval => "1440",
		 notification_interval => "50400",
		 notification_period => "workhours",
		 notification_options => "w,c",
		 ensure => "absent",
  }

}
