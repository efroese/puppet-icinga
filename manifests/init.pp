# $Id$

class icinga(
    $nagios_conf_dir="/etc/icinga/objects.d",
    ) {

    $nagiosplugins = $architecture ? {
        x86_64  => '/usr/lib64/nagios/plugins',
        default => '/usr/lib/nagios/plugins',
    }
}

define icinga::object ($path = "",
    $content,
    $ensure = "present") {

    #nagios cannot read file with dots "."
    $name_real = regsubst($name, '\.', '-')
    $path_real = $path ? {
        "" => "${icinga::nagios_conf_dir}/${name_real}",
        default => $path,
    }
    #notice("${fqdn}: Setting nagios3 name: ${name}, check: ${name_real} and: ${path_real}")
    @@file { "${path_real}.cfg" :
        ensure => $ensure,
        content => $content,
        owner => "icinga",
        group => "apache",
        tag => 'icinga_object',
        mode => 0644,
        purge => true,
    }
}

import "defines/*.pp"
import "classes/*.pp"
