# $Id$

class nagios::check::raid::software {
  nagios2_nrpe_plugin {"${fqdn}_checkraid":
    service_description => "CHECKRAID",
			command_name => "check_raid",
			notification_options => "w,c,u",
  }
}

class nagios::check::raid::three_ware {
  $prese_real = $presence ? { 
    "absent" => "absent",
      default => "present"
  }
  nagios2_nrpe_plugin {"${fqdn}_checkraid":
    service_description => "CHECKRAID",
			command_name => "check_3ware_raid",
			notification_options => "w,c,u",
			sudo => true,
			ensure => $prese_real,
  }
}
class nagios::check::raid::three_ware::none {
  $presence = "absent"
    include nagios::check::raid::three_ware
}

