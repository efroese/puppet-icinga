# $Id$
class icinga::monitored::common {
    icinga::service {
        "${fqdn}_ssh" :
            service_description => "SSH",
            check_command => "check_ssh",
            notification_period => "workhours",
    }
    icinga::service {
        "${fqdn}_ping" :
            service_description => "PING",
            check_command => "check_ping!125.0,20%!500.0,60%",
            dependent_service_description => "",
    }
    icinga::service {
        "${fqdn}_load" :
            service_description => "LOAD",
            check_command => "check_load",
            ensure => "absent"
    }
    file {
        "/usr/lib/nagios/plugins" :
            source => "puppet:///modules/icinga/plugins",
            recurse => true,
            ensure => $ensure,
    }
    case $kernel {
        "Linux" : {
            $apt_present = "present"
        }
        default : {
            $apt_present = "absent"
        }
    }
    icinga::nrpe_service {
        "${fqdn}_nrpe_apt" :
            command_name => "check_apt",
            command_line =>
            "${icinga::monitored::server::nrpe::nagiosplugins}/check_apt",
            service_description => "APT",
            normal_check_interval => "1440",
            notification_interval => "50400",
            notification_period => "workhours",
            notification_options => "w,c",
    }
    icinga::nrpe_command {
        "check_disk" :
            command_line => "/usr/lib/nagios/plugins/check_disk -c 10% -w 20%",
    }  
}
