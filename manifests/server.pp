# $Id$
class icinga::server (
    $ensure = "present",
    $db_servertype = 'mysql',
    $db_host       = 'localhost',
    $db_port       = '3306',
    $db_name       = 'icinga',
    $db_user       = 'icinga',
    $db_pass       = 'icinga',
    $icinga_cfg_template = 'icinga/icinga.cfg.erb',
    $ido2db_template     = 'icinga/ido2db.cfg.erb',
    $active_services     = true,
    $passive_services    = true,
    $mysql_root_pw
    ) {

    Class['Icinga::Params'] -> Class['Icinga::Server']

    if ! defined(Class['Icinga::Params']){
        class { 'icinga::params': }
    }

    class { 'icinga::repos': }

    user { 'icinga':
        groups => ['icinga', 'icingacmd'],
        require => [Group['icinga'], Group['icingacmd'], ],
    }

    group { ['icinga', 'icingacmd', ]: }

    package { ['icinga', 'icinga-api', 'icinga-doc', 'icinga-gui', 'icinga-idoutils',
                'libdbi', 'libdbi-drivers', 'libdbi-dbd-mysql', ] :
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

    file { '/etc/icinga/ido2db.cfg':
        ensure => present,
        owner => icinga,
        group => icinga,
        mode  => 664,
        content => template($ido2db_template),
        require => Package['icinga-idoutils'],
    }

    file { '/etc/icinga/icinga.cfg':
        ensure => present,
        owner => icinga,
        group => icinga,
        mode  => 664,
        content => template($icinga_cfg_template),
        require => Package['icinga'],
    }

    exec { 'icinga-create-mysqldb':
        command => "mysql --user=${db_user} --password=${db_pass} ${db_name} < /etc/icinga/idoutils/mysql/mysql.sql",
        unless  => "mysql --user=${db_user}--password=${db_pass} ${db_name} -e 'describe icinga_dbversion'",
        require => [ Package['icinga-idoutils'], Package['icinga'] ],
    }

    service { "icinga" :
        ensure => running,
        enable => true,
        require => Package["icinga"],
        subscribe => [
            File['/etc/icinga/icinga.cfg'],
            File[$icinga::params::nagios_conf_dir],
        ],
    }

    service { "ido2db" :
        ensure => running,
        enable => true,
        require => [ Package["icinga-idoutils"], Exec['icinga-create-mysqldb'] ],
        subscribe => File['/etc/icinga/ido2db.cfg'],
    }

    # might already be defined by a nagios module
    if ! defined(File[$icinga::params::nagios_conf_dir]) {
        file { $icinga::params::nagios_conf_dir :
            ensure => directory,
            require => Package['icinga'],
        }
    }

    # Collect basic icinga objects. The things all icinga servers in a distributed setup share.
    # commands, timeperiods, contacts, servicegroups, hostgroups, macros, ...
    File <<| tag == 'icinga_basic_object' |>> {
        notify => Service["icinga"],
        purge => true
    }

    # Collect the icinga hosts for this server
    # nodes should tag their icinga::host with the local and central nagios fqdns
    File <<| tag == "icinga_host_${::fqdn}" |>> {
        notify => Service["icinga"],
        purge => true
    }

    # Collect active icinga services
    if $active_services == true {
        File <<| tag == "icinga_active_${::fqdn}" |>> {
            notify => Service["icinga"],
            purge => true
        }
    }

    # Collect passive icinga services
    if $passive_services == true {
        File <<| tag == "icinga_passive_${::fqdn}" |>> {
            notify => Service["icinga"],
            purge => true
        }
    }

    file {
        ["${icinga::params::nagios_conf_dir}/localhost_icinga.cfg",
         "${icinga::params::nagios_conf_dir}/hostgroups_icinga.cfg",
         "${icinga::params::nagios_conf_dir}/services_icinga.cfg",
         "${icinga::params::nagios_conf_dir}/extinfo_icinga.cfg"] :
            ensure => absent,
    }
}
