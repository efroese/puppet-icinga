class icinga::nsca::receiver ($ensure = "present") {

    notice("NSCA should be \"${ensure}\"")

    package { "nagios-nsca" :
        ensure => $ensure
    }

    service { "nsca" :
        ensure => running,
        enabled => true,
        require => Package["nagios-nsca"],
    }

    icinga::service { "${fqdn}_nsca_receiver" :
        service_description => "nsca",
        check_command => "check_tcp!5667",
        ensure => $ensure,
    }

    icinga::command { "dummy_command_for_nsca" :
        command_name => "check_dummy",
        command_line => "/usr/lib/nagios/plugins/check_dummy \$ARG1\$ \$ARG2\$",
        ensure => "present",
    }
}