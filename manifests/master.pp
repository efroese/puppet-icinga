# $Id$
class icinga::master (
    $ensure = "present",
    $db_servertype = 'mysql',
    $db_host       = 'localhost',
    $db_port       = '3306',
    $db_name       = 'icinga',
    $db_user       = 'icinga',
    $db_pass       = 'icinga',
    $icinga_cfg_template = 'icinga/icinga.cfg.erb',
    $ido2db_template     = 'icinga/ido2db.cfg.erb'
    ) {

    class { 'icinga::params': }
    class { 'icinga::repos': }

    user { 'icinga':
        groups => ['icinga', 'icingacmd'],
        require => [Group['icinga'], Group['icingacmd'], ],
    }

    group { ['icinga', 'icingacmd', ]: }

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
    package { ['php', 'php-cli', 'php-pear', 'php-xmlrpc', 'php-xsl', 'php-pdo', 'php-gd', 'php-ldap', 'php-mysql', 'perl-Locale-PO']:
        ensure => $ensure,
        require => Class['Icinga::Repos'],
    }

    package { 'icinga-web-1.6.1-1.el6.noarch':
        source => 'http://wiki.nikoforge.org/download/icinga/icinga-rpm.oetken.cc/icinga-web-1.6.1-1.el6.noarch.rpm',
        ensure => installed,
    }

    file { '/etc/icinga/ido2db.cfg':
        ensure => present,
        owner => icinga,
        group => icinga,
        mode  => 664,
        content => template($ido2db_template),
    }

    file { '/etc/icinga/icinga.cfg':
        ensure => present,
        owner => icinga,
        group => icinga,
        mode  => 664,
        content => template($icinga_cfg_template),
    }

    service { "icinga" :
        ensure => running,
        enable => true,
        require => Package["icinga"],
        subscribe => File[$icinga::params::nagios_conf_dir],
    }

    # might already be defined by a nagios module
    if ! defined(File[$icinga::params::nagios_conf_dir]) {
        file { $icinga::params::nagios_conf_dir :
            ensure => directory,
        }
    }

    #collect all nagios_ definitions
    File <<| tag == "icinga_object" |>> {
        notify => Service["icinga"],
        purge => true
    } 

    file {
        ["${icinga::params::nagios_conf_dir}/localhost_icinga.cfg",
         "${icinga::params::nagios_conf_dir}/hostgroups_icinga.cfg",
         "${icinga::params::nagios_conf_dir}/services_icinga.cfg",
         "${icinga::params::nagios_conf_dir}/extinfo_icinga.cfg"] :
            ensure => absent,
    }
}
