# $Id$

$NAGIOSCONFDIR="/etc/nagios2/conf.d"

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

   #notice ("Setting nagios2 check: ${name_real} and: ${path_real}")
   @@file { "${path_real}.cfg":
   ensure => $ensure,
      content => $content,
      notify => Service["nagios2"],
      tag => "nagios",
   }
}

import "nagios_*.pp"
import "defines/*pp"
import "classes/*.pp"
