# $Id$
class icinga::master ($ensure = "present", $nagios_conf_dir) {
    package { ["icinga-core", "icinga-phpapi", "icinga-idoutils"] :
        ensure => $ensure
    }

    ### ICINGA WEB2 #####
    package { ["php-pear", "php5-xsl", "php5-ldap", "php5-pgsql", "php5-mysql", "php5-xmlrpc"] :
        ensure => $ensure,
    }

    service { "icinga" :
        ensure => running,
        enabled => 1,
        require => Package["icinga-core"],
        subscribe => File[$nagios_conf_dir],
    }

    file { $nagios_conf_dir :
        ensure => directory,
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

    Icinga::Hostgroup {
        ensure => $ensure,
    }
    icinga::hostgroup {
        ["Debian", "Ubuntu", "FreeBSD", "Darwin"] :
    }
    icinga::hostgroup {
        ["Physical", "Xenu", "Xen0", "Kvm"] :
    }
    icinga::hostgroup {
        ["ppc", "amd64", "i386", "x86_64"] :
    }
    icinga::servicegroup {
        ["Harddrives", "Sensors", "Memory"] :
    }
    ##some additional commands
    icinga::command {
        "check-nfsv4" :
            command_line =>
            "/usr/lib/nagios/plugins/check_rpc -H \$HOSTADDRESS\$ -C nfs -c2,3,4",
    }
    icinga::command {
        "check-nfsv4-tcp" :
            command_line =>
            "/usr/lib/nagios/plugins/check_rpc -H \$HOSTADDRESS\$ -C nfs -t -c2,3,4",
    }
    icinga::command {
        "check-nfsv3" :
            command_line =>
            "/usr/lib/nagios/plugins/check_rpc -H \$HOSTADDRESS\$ -C nfs -c2,3",
    }
    icinga::command {
        "check-nfsv3-tcp" :
            command_line =>
            "/usr/lib/nagios/plugins/check_rpc -H \$HOSTADDRESS\$ -C nfs -t -c2,3",
    }
    icinga::command {
        "check_nrpe" :
            command_line =>
            "/usr/lib/nagios/plugins/check_nrpe -t 60 -H \$HOSTADDRESS\$ -c \$ARG1\$ -a \$ARG2\$",
    }
    icinga::command {
        "check_nrpe_1arg" :
            command_line =>
            "/usr/lib/nagios/plugins/check_nrpe -t 60 -H \$HOSTADDRESS\$ -c \$ARG1\$",
    }
    icinga::command {
        "check-rpc-tcp" :
            command_line =>
            "/usr/lib/nagios/plugins/check_rpc -H \$HOSTADDRESS\$ -C \$ARG1\$ -t",
    }
    icinga::command {
        "check-rpc-version" :
            command_line =>
            "/usr/lib/nagios/plugins/check_rpc -H \$HOSTADDRESS\$ -C \$ARG1\$ -c \$ARG2\$",
    }
    icinga::command {
        "check-rpc-version-tcp" :
            command_line =>
            "/usr/lib/nagios/plugins/check_rpc -H \$HOSTADDRESS\$ -t -C \$ARG1\$ -c \$ARG2\$",
    }
}
