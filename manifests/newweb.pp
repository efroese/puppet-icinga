class icinga::newweb(
    $ensure  = 'present',
    $db_user = 'icinga_web',
    $db_pass = 'icinga_web',
    $db_host = 'localhost'
    ) {
    
    package { ['php', 'php-cli', 'php-pear', 'php-xmlrpc', 'php-pdo', 'php-gd', 'php-ldap', 'php-mysql', 'perl-Locale-PO']:
        ensure => $ensure,
        require => Class['Icinga::Repos'],
    }

    package { 'icinga-web-1.6.1-1.el6.noarch':
        source => 'http://wiki.nikoforge.org/download/icinga/icinga-rpm.oetken.cc/icinga-web-1.6.1-1.el6.noarch.rpm',
        provider => rpm,
        ensure => installed,
    }

    exec { 'icinga-create-mysqldb':
        command => "mysql --user=${db_user} --password=${db_pass} ${db_name} < /usr/share/icinga-web/etc/schema/mysql.sql",
        unless  => "mysql --user=${db_user}--password=${db_pass} ${db_name} -e 'describe nsm_user_role'",
        require => Package['icinga-web-1.6.1-1.el6.noarch'],
    }
}