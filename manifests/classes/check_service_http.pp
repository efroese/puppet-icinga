# $Id$


class nagios::check::http::all{
  nagios2_service{ "${fqdn}_http":
    service_description => "HTTP",
			check_command => "check_http!${ipaddress}!${ipaddress}",
  }
  nagios2_service{ "${fqdn}_https":
    service_description => "HTTPS",
			check_command => "check_https!${ipaddress}!${ipaddress}",
  }

}

class nagios::check::http{
  nagios2_service{ "${fqdn}_http":
    service_description => "HTTP",
			check_command => "check_http!${fqdn}!${ipaddress}",
  }
  nagios2_service{ "${fqdn}_https":
    service_description => "HTTPS",
			check_command => "check_https!${fqdn}!${ipaddress}",
			ensure => absent,
  }
}

  class nagios::check::https {
    $fqdn_real = downcase($fqdn)
      nagios2_service{ "${fqdn}_https":
	service_description => "HTTPS",
			    check_command => "check_https!${fqdn_real}!${ipaddress}",
      }
    nagios2_service{ "${fqdn}_http":
      service_description => "HTTP",
			  check_command => "check_http!${fqdn_real}!${ipaddress}",
			  ensure =>absent,
    }

  }

class nagios::check::http_tcp{
  nagios2_service{ "${fqdn}_http":
    service_description => "HTTP",
			check_command => "check_http!${fqdn}!${ipaddress}",
			ensure => absent,
  }
  nagios2_service{ "${fqdn}_https":
    service_description => "HTTPS",
			check_command => "check_https!${fqdn}!${ipaddress}",
			ensure => absent,
  }
  nagios2_service{ "${fqdn}_http_tcp":
    service_description => "HTTPTCP",
			check_command => "check_tcp!80",
  }
}

class nagios::check::http_tcp::all{
  nagios2_service{ "${fqdn}_http":
    service_description => "HTTP",
			check_command => "check_http!${fqdn}!${ipaddress}",
			ensure => absent,
  }
  nagios2_service{ "${fqdn}_https":
    service_description => "HTTPS",
			check_command => "check_https!${fqdn}!${ipaddress}",
			ensure => absent,
  }
  nagios2_service{ "${fqdn}_http_tcp":
    service_description => "HTTPTCP",
			check_command => "check_tcp!80",
  }
  nagios2_service{ "${fqdn}_https_tcp":
    service_description => "HTTPSTCP",
			check_command => "check_tcp!443",
  }
}

class nagios::check::http::none{
  nagios2_service{ "${fqdn}_http":
    service_description => "HTTP",
			check_command => "check_http!${fqdn}!${ipaddress}",
			ensure => absent,
  }
  nagios2_service{ "${fqdn}_https":
    service_description => "HTTPS",
			check_command => "check_https!${fqdn}!${ipaddress}",
			ensure => absent,
  }
  nagios2_service{ "${fqdn}_http_tcp":
    service_description => "HTTPTCP",
			check_command => "check_tcp!80",
			ensure => absent,
  }

  nagios2_service{ "${fqdn}_https_tcp":
    service_description => "HTTPSTCP",
			check_command => "check_tcp!443",
			ensure => absent,
  }
}
