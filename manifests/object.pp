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
    $name_real = regsubst($name, '[-\.:\W]', '_', 'G')
    $path_real = $path ? {
        "" => "${icinga::params::nagios_conf_dir}/${name_real}",
        default => $path,
    }

    $default_tags = [ 'icinga_object', 'icinga_basic_object' ]

    $the_tags = $icinga_tags ? {
        '' => $default_tags,
        'icinga_basic_object' => $default_tags,
        'icinga_object' => $default_tags,
        default => split(inline_template("<%= icinga_tags.flatten.join(',') %>"),','),
    }
  
    notice("${fqdn}: Exporting : ${path_real}.cfg")
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
