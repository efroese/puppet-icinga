# $Id$

class nagios::check::mysql {
  nagios2_service {"${fqdn}_mysql":
    service_description => "MYSQL",
			check_command => "check_mysql",
			notification_options => "w,c,u",
  }
  $nagioshost = gethostname($NAGIOS_HOST)
    @@mysql_user{"nagios@${nagioshost}": ensure => "present", password_hash => "" }
}

class nagios::check::pgsql {
  nagios2_service {"${fqdn}_pgsql":
    service_description => "POSTGRESQL",
			check_command => "check_pgsql2",
			notification_options => "w,c,u",
  }
}
