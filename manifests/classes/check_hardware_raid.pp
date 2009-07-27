# $Id$

class nagios::check::raid::software {
  $prese_real = $presence ? { 
      "absent" => "absent",
        default => $has_raid ? {
          "false" => "absent",
            default => "present"
        }
    }
  nagios2_nrpe_plugin {"${fqdn}_checkraid":
    service_description => "CHECKRAID",
			command_name => "check_raid",
			servicegroups => "Harddrives",
			notification_options => "w,c,u",
    ensure => $prese_real,
  }
}
  class nagios::check::raid::software::none {
    $presence = "absent"
    include nagios::check::raid::software
  }

class nagios::check::raid::three_ware {
  $prese_real = $presence ? { 
    "absent" => "absent",
      default => $has_raid ? {
        "false" => "absent",
          default => "present"
      }
  }
  nagios2_nrpe_plugin {"${fqdn}_checkraid":
    service_description => "CHECKRAID",
			command_name => "check_3ware_raid",
			notification_options => "w,c,u",
			sudo => true,
			servicegroups => "Harddrives",
			ensure => $prese_real,
  }
}
class nagios::check::raid::three_ware::none {
  $presence = "absent"
    include nagios::check::raid::three_ware
}

