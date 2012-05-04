#
# = Class icinga::object
# This object packages up an icinga object as a file and exports it. 
#
define icinga::object (
    $path = "",
    $content,
    $ensure = "present",
    $tag = "") {

    #nagios cannot read file with dots "."
    $name_real = regsubst($name, '\.', '-')
    $path_real = $path ? {
        "" => "${icinga::params::nagios_conf_dir}/${name_real}",
        default => $path,
    }
    #notice("${fqdn}: Setting nagios3 name: ${name}, check: ${name_real} and: ${path_real}")
    @@file { "${path_real}.cfg" :
        ensure => $ensure,
        content => $content,
        owner => "icinga",
        group => "apache",
        tag => $tag ? {
            "" => 'icinga_object'
            default => [ $tag, 'icinga_object' ],
        },
        mode => 0644,
        purge => true,
    }
}