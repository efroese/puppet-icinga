#
# = Class icinga::object
# This object packages up an icinga object as a file and exports it. 
#
define icinga::object (
    $path = "",
    $content,
    $ensure = "present",
    $icinga_tags = "") {

    #nagios cannot read file with dots "."
    $name_real = regsubst($name, '\.', '-')
    $path_real = $path ? {
        "" => "${icinga::params::nagios_conf_dir}/${name_real}",
        default => $path,
    }

    $the_tags = $icinga_tags ? {
        "" => [ 'icinga_object' ],
        default => split(inline_template("<%= icinga_tags.flatten.join(',') %>"),','),
    }
  
    #notice("${fqdn}: Setting nagios3 name: ${name}, check: ${name_real} and: ${path_real}")
    @@file { "${path_real}.cfg" :
        ensure => $ensure,
        content => $content,
        owner => "icinga",
        group => "apache",
        tag => $the_tags,
        mode => 0644,
        purge => true,
    }
}
