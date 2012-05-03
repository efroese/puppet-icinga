class nagios::nsca::sender(
    $ensure = "present"
    $icinga_receiver) {

    package { "nsca" :
        ensure => $ensure
    }

    service { "nsca" :
        ensure => "stopped",
        require => Package["nsca"],
    }

    file_line { "munin_nsca_sender" :
        file => "/etc/munin/munin.conf",
        line => "contacts nagios",
        ensure => $ensure,
    }

    file_line { "munin_nsca_sender_command" :
        file => "/etc/munin/munin.conf",
        line => "contact.nagios.command /usr/sbin/send_nsca -H ${icinga_receiver} -to 60 -c /etc/send_nsca.cfg",
        ensure => $ensure,
    }
}