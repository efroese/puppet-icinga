# $Id$
class icinga::master ($ensure = "present", $nagios_conf_dir) {

    class { 'icinga::repos': }

    package { ['icinga', 'icinga-api', 'icinga-doc', 'icinga-gui',
               'icinga-idoutils', 'libdbi', 'libdbi-drivers',
               'nagios-plugins-all', ] :
        ensure => $ensure,
        require => Class['Icinga::Repos'],
    }

    package { [ 'gcc', 'glibc', 'glibc-common', 'gd', 'gd-devel',
                'libjpeg', 'libjpeg-devel', 'libpng', 'libpng-devel' ]:
        ensure => $ensure
    }

    ### ICINGA WEB2 #####
    #package { ["php-pear", "php5-xsl", "php5-ldap", "php5-pgsql", "php5-mysql", "php5-xmlrpc"] :
    #    ensure => $ensure,
    #}

    service { "icinga" :
        ensure => running,
        enable => true,
        require => Package["icinga"],
        subscribe => File[$nagios_conf_dir],
    }

    # might already be defined by a nagios module
    if ! defined(File[$nagios_conf_dir]) {
        file { $nagios_conf_dir :
            ensure => directory,
        }
    }

    #collect all nagios_ definitions
    File <<| tag == "icinga_object" |>> {
        notify => Service["icinga"],
        purge => true
    } 

    file {
        ["${nagios_conf_dir}/localhost_icinga.cfg",
         "${nagios_conf_dir}/hostgroups_icinga.cfg",
         "${nagios_conf_dir}/services_icinga.cfg",
         "${nagios_conf_dir}/extinfo_icinga.cfg"] :
            ensure => absent,
    }
    
    $nagiosplugins = $operatingsystem ? {
        "FreeBSD" => "/usr/local/libexec/nagios",
        default => "/usr/lib/nagios/plugins",
    }
}
