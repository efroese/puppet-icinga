# $Id$

class icinga {

    $nagios_conf_dir="/etc/icinga/objects"

    $nrpe_d = $operatingsystem ? {
        "FreeBSD" => "/usr/local/etc/nrpe.d",
        "Darwin" => "/opt/local/etc/nrpe/nrpe.d",
        default => "/etc/nagios/nrpe.d",
    }

    $nagiosplugins = "/usr/lib64/nagios/plugins"

    user { 'icinga':
        groups => ['icinga', 'icingacmd'],
        require => [Group['icinga'], Group['icingacmd'], ],
    }

    group { ['icinga', 'icingacmd', ]: }
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
    @@file {
        "${path_real}.cfg" :
            ensure => $ensure,
            content => $content,
            owner => "nagios",
            group => "apache",
            tag => "icinga_object",
            mode => 0644,
            purge => true,
    }
}

import "defines/*.pp"
import "classes/*.pp"
