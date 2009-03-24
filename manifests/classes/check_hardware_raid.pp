# $Id$

class nagios::check::raid::software {
  nagios2_nrpe_plugin {"${fqdn}_checkraid":
    service_description => "CHECKRAID",
			command_name => "check_raid",
			notification_options => "w,c,u",
  }
}

class nagios::check::raid::three_ware {
  nagios2_nrpe_plugin {"${fqdn}_checkraid":
    service_description => "CHECKRAID",
			command_name => "check_3ware_raid",
			notification_options => "w,c,u",
			sudo => true,
  }
}

