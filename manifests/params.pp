#
# = Class icinga::params
# Holds config variables for icinga
#
class icinga::params {
    
    $nagios_conf_dir = '/etc/icinga/objects.d'

    $lib_dir = $architecture ? {
        x86_64  => '/usr/lib64',
        default => '/usr/lib',
    }

    $nagiosplugins = "${lib_dir}/nagios/plugins"
    $eventhandlers = "${lib_dir}/nagios/eventhandlers"

    file { "${lib_dir}/nagios":
        ensure => directory,
        mode   => 0755,
    }

    file { $eventhandlers:
        ensure  => directory,
        mode    => 0755,
        require => File["${lib_dir}/nagios"],
    }
}
