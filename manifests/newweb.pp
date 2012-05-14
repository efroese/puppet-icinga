#
# = Class: icinga::newweb
# Install the icinga php interface
#
# == Paramters
# $db_name:: The name fo the db to use for the web interface
#
# $db_user:: The db username
#
# $db_pass:: The db user password
#
# $db_host:: The host the db runs on
#
class icinga::newweb(
    $ensure  = 'present',
    $db_name = 'icinga_web',
    $db_user = 'icinga_web',
    $db_pass = 'icinga_web',
    $db_host = 'localhost'
    ) {
    
    package { ['php', 'php-cli', 'php-pear', 'php-xmlrpc', 'php-pdo', 'php-gd', 'php-ldap', 'php-mysql', 'perl-Locale-PO']:
        ensure => $ensure,
        require => Class['Icinga::Repos'],
    }

    $icinga_pkg = 'icinga-web-1.6.1-1.el6.noarch'

    package { $icinga_pkg:
        source => "http://wiki.nikoforge.org/download/icinga/icinga-rpm.oetken.cc/${icinga_pkg}.rpm",
        provider => rpm,
        ensure => installed,
    }

    exec { 'icinga-create-newweb-mysqldb':
        command => "mysql --user=${db_user} --password=${db_pass} ${db_name} < /usr/share/icinga-web/etc/schema/mysql.sql",
        unless  => "mysql --user=${db_user} --password=${db_pass} ${db_name} -e 'describe nsm_user_role'",
        require => Package[$icinga_pkg],
    }
}
