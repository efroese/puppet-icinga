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

   #notice ("Setting nagios3 check: ${name_real} and: ${path_real}")
   @@file { "${path_real}.cfg":
   ensure => $ensure,
      content => $content,
      notify => Service["nagios3"],
      tag => "nagios",
      owner => "nagios",
      group => "www-data",
      mode => 0644,
   }
}

import "nagios_*.pp"
import "defines/*pp"
import "classes/*.pp"
