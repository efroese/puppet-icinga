# $Id$
class icinga::master ($ensure = "present") {
    package {
        ["icinga-core", "icinga-phpapi", "icinga-idoutils"] :
            ensure => $ensure
    }
    ### ICINGA WEB2 #####
    package {
        ["php-pear", "php5-xsl", "php5-ldap", "php5-pgsql", "php5-mysql",
        "php5-xmlrpc"] :
            ensure => $ensure,
    }

    #  icinga::service { "${fqdn}_mem_percent_nagios":
    #    service_description => "mem_percent_nagios",
    #    check_command => "check_ganglia!mem_percent_nagios!70!90!${ganglia_metaserver_ip}",
    #    servicegroups => "Memory",
    #    notification_options => "c,u",
    #    ensure => "absent",
    #  } 
    service {
        "icinga" :
            ensure => running,
            require => Package["icinga-core"],
            subscribe => File[$NAGIOSCONFDIR],
    }

    #collect all nagios_ definitions
    File <<| tag == "icinga_object" |>> {
        notify => Service["icinga"],
        purge => true
    } 
    file {
        $NAGIOSCONFDIR :
            ensure => directory,
    }
    file {
        ["${NAGIOSCONFDIR}/localhost_icinga.cfg",
        "${NAGIOSCONFDIR}/hostgroups_icinga.cfg",
        "${NAGIOSCONFDIR}/services_icinga.cfg",
        "${NAGIOSCONFDIR}/extinfo_icinga.cfg"] :
            ensure => absent,
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
    #icinga::hostgroup{["Harddrives","Sensors"]: ensure => "absent", purge => true }
    icinga::servicegroup {
        ["Harddrives", "Sensors", "Memory"] :
    }

    #  remotefile {"${NAGIOSCONFDIR}/timeperiods_nagios3.cfg":
    #    ensure => present,
    #    source => "timeperiods_nagios3.cfg",
    #    module => "nagios",
    #    mode=> "0644",
    #    notify => Service["nagios3"],
    #  }

    ### purge all resources
    #  resources{["icinga::command", 
    #    "icinga::host", 
    #    "icinga::service",
    #    "icinga::contact" ]:
    #    purge => true,
    #  }
    #  
    #  if ! defined(resources["file"]) {
    #    resources{["file"]:
    #        purge => true,
    #      noop => true,
    #      }
    #  }

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
    $nagiosplugins = $operatingsystem ? {
        "FreeBSD" => "/usr/local/libexec/nagios",
        default => "/usr/lib/nagios/plugins",
    }
    file {
        "${nagiosplugins}/check_ganglia" :
            source => "puppet:///modules/ganglia/contrib/check_ganglia",
            mode => 0755,
    }
}
class icinga::nsca::receiver ($ensure = "present") {
    notice("NSCA should be \"${ensure}\"") package {
        "nsca" :
            ensure => $ensure
    }
    service {
        "nsca" :
            ensure => "stopped",
            require => Package["nsca"],
    }
    xinetd::service {
        "nsca" :
            server => "/usr/sbin/nsca",
            server_args => "-c /etc/nsca.cfg --inetd",
            user => "nagios",
            group => "nagios",
            only_from => "127.0.0.1 ganglia.ikw.Uni-Osnabrueck.DE",
            port => 5667,
            ensure => $ensure,
    }
    icinga::service {
        "${fqdn}_nsca_receiver" :
            service_description => "nsca",
            check_command => "check_tcp!5667",
            ensure => $ensure,
    }
    icinga::command {
        "dummy_command_for_nsca" :
            command_name => "check_dummy",
            command_line =>
            "/usr/lib/nagios/plugins/check_dummy \$ARG1\$ \$ARG2\$",
            ensure => "present",
    }
}
class nagios::nsca::sender ($ensure = "present") {
    package {
        "nsca" :
            ensure => $ensure
    }
    service {
        "nsca" :
            ensure => "stopped",
            require => Package["nsca"],
    }
    line {
        "munin_nsca_sender" :
            file => "/etc/munin/munin.conf",
            line => "contacts nagios",
            ensure => $ensure,
    }
    line {
        "munin_nsca_sender_command" :
            file => "/etc/munin/munin.conf",
            line =>
            "contact.nagios.command /usr/sbin/send_nsca -H ${NAGIOS_HOST} -to 60 -c /etc/send_nsca.cfg",
            ensure => $ensure,
    }
}
