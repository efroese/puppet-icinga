#
# = Class icinga::params
# Holds config variables for icinga
#
# == Parameters
#
# $nagios_conf_dir:: Where to store the generated icinga/nagios objects.
#
# $nagiosplugins:: The path to the nagios plugins
#
class icinga::params (
    $nagios_conf_dir = "/etc/icinga/objects.d",
    $nagiosplugins = ''
    ) {

    $nagiosplugins = $nagiosplugins ? {
        '' =>  $architecture ? {
            x86_64  => '/usr/lib64/nagios/plugins',
            default => '/usr/lib/nagios/plugins',
        },
        default => $nagiosplugins,
    }

}
