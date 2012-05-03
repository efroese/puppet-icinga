class icinga::nsca::sender ($munin_enabled=false)(
    $ensure = "present",
    $nsca_receiver) {

    package { "nagios-nsca" :
        ensure => $ensure
    }

    service { "nsca" :
        ensure => "stopped",
        require => Package["nagios-nsca"],
    }

    if $munin_enabled == true {
        file_line { "munin_nsca_sender" :
            path => "/etc/munin/munin.conf",
            line => "contacts nagios",
            ensure => $ensure,
        }

        file_line { "munin_nsca_sender_command" :
            file => "/etc/munin/munin.conf",
            line => "contact.nagios.command /usr/sbin/send_nsca -H ${icinga_receiver} -to 60 -c /etc/send_nsca.cfg",
            ensure => $ensure,
        }
    }
}