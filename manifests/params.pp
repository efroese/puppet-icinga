#
# = Class icinga::params
# Holds config variables for icinga
#
class icinga::params {
    
    $nagios_conf_dir = '/etc/icinga/objects.d'

    $nagiosplugins = $architecture ? {
        x86_64  => '/usr/lib64/nagios/plugins',
        default => '/usr/lib/nagios/plugins',
    }
}