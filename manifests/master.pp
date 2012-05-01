# $Id$
class icinga::master (
    $ensure = "present",
    $nagios_conf_dir,
    $db_servertype = 'mysql',
    $db_host       = 'localhost',
    $db_port       = '3306',
    $db_name       = 'icinga',
    $db_user       = 'icinga',
    $db_pass       = 'icinga',
    $ido2db_template = 'icinga/ido2db.cfg.erb'
    ) {

    class { 'icinga::repos': }

    package { ['icinga', 'icinga-api', 'icinga-doc', 'icinga-gui',
               'icinga-idoutils', 'libdbi', 'libdbi-drivers', ] :
        ensure => $ensure,
        require => Class['Icinga::Repos'],
    }

    package { [ 'gcc', 'glibc', 'glibc-common', 'gd', 'gd-devel',
                'libjpeg', 'libjpeg-devel', 'libpng', 'libpng-devel' ]:
        ensure => $ensure
    }

    # might already be defined by a nagios module
    if ! defined(Package['nagios-plugins-all']){
        package { 'nagios-plugins-all': ensure => installed }
    }

    ### ICINGA WEB2 #####
    #package { ["php-pear", "php5-xsl", "php5-ldap", "php5-pgsql", "php5-mysql", "php5-xmlrpc"] :
    #    ensure => $ensure,
    #}

    file { '/etc/icinga/ido2db.cfg',
        ensure => present,
        owner => icinga,
        group => icinga,
        mode  => 664,
        content => template($ido2db_template),
    }

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
}
