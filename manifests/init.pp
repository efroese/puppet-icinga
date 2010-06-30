# $Id$

$NAGIOSCONFDIR="/etc/nagios3/conf.d"

define nagios2file(
    $path="",
    $content,
    $ensure = "present"
    )
{
#nagios cannot read file with dots "."
     
  $name_real = convert($name,'.','-')
    $path_real = $path ? {
      "" => "${NAGIOSCONFDIR}/${name_real}",
      default => $path,
    }
     # notice ("${fqdn}: Setting nagios3 name: ${name}, check: ${name_real} and: ${path_real}")
  @@file { "${path_real}.cfg":
    ensure => $ensure,
    content => $content,
    tag => "nagios",
    owner => "nagios",
    group => "www-data",
    notify => Service["nagios3"],
    mode => 0644,
  }
}

import "nagios_*.pp"
import "defines/*pp"
import "classes/*.pp"
