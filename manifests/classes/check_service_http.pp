# $Id$

class icinga::check::http::all ($ensure = "present") {
  class{["icinga::check::http", "icinga::check::https"]:
      ensure => $ensure,
    }
}

class icinga::check::http ($ensure = "present") {
    Icinga::Service { ensure => $ensure }
  icinga::service{ "${fqdn}_http":
    service_description => "HTTP",
			check_command => "check_http!${fqdn}!${ipaddress}",
  }
}

  class icinga::check::https ($ensure = "present") {
      Icinga::Service { ensure => $ensure }
    $fqdn_real = downcase($fqdn)
      icinga::service{ "${fqdn}_https":
	       service_description => "HTTPS",
			    check_command => "check_https!${fqdn_real}!${ipaddress}",
      }

  }

class icinga::check::http_tcp($ensure="present"){
    Icinga::Service { ensure => $ensure }
  icinga::service{ "${fqdn}_http_tcp":
    service_description => "HTTPTCP",
			check_command => "check_tcp!80",
  }
}

class icinga::check::http_tcp::all($ensure="present"){
  Icinga::Service { ensure => $ensure }
  icinga::service{ "${fqdn}_http_tcp":
    service_description => "HTTPTCP",
			check_command => "check_tcp!80",
  }
  icinga::service{ "${fqdn}_https_tcp":
    service_description => "HTTPSTCP",
			check_command => "check_tcp!443",
  }
}
