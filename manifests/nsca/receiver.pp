class icinga::nsca::receiver (
    $ensure = "present",
    $nsca_cfg = 'icinga/nsca.cfg.erb'
    ) {

    Class['Icinga::params'] -> Class['Icinga::Nsca::Receiver']

    notice("NSCA should be \"${ensure}\"")

    package { "nagios-nsca" :
        ensure => $ensure
    }

    file { '/etc/nagios/nsca.cfg':
        owner => root,
        group => root,
        mode  => 0644,
        content => template($nsca_cfg)
    }

    service { "nsca" :
        ensure => running,
        enable => true,
        require => Package["nagios-nsca"],
    }

    icinga::service { "${fqdn}_nsca_receiver" :
        service_description => "nsca",
        check_command => "check_tcp!5667",
        ensure => $ensure,
    }

    icinga::command { "dummy_command_for_nsca" :
        command_name => "check_dummy",
        command_line => '$USER1$/check_dummy $ARG1$ $ARG2$',
        ensure => "present",
    }
}
