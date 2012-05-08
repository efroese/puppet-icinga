class icinga::nsca::sender (
    $ensure = "present",
    $nsca_receiver,
    $munin_enabled = false) {

    package { "nagios-nsca" :
        ensure => $ensure
    }

    service { "nsca" :
        ensure => "stopped",
        require => Package["nagios-nsca"],
    }

    file { '/etc/icinga/send_nsca.cfg':
        owner => root,
        group => root,
        mode  => 0644,
        content => template('icinga/send_nsca.cfg.erb'),
    }

    file { $icinga::params::eventhandlers:
       ensure => directory,
       owner => root,
       group => root,
       mode  => 0755,
    }

    file { "${icinga::params::eventhandlers}/submit_check_result":
        owner => root,
        group => root,
        mode  => 0755,
        content => template('icinga/submit_check_result.erb'),
        require => File[$icinga::params::eventhandlers],
    }

    icinga::command { 'submit_check_result':
        ensure => present,
        command_line => "${icinga::params::eventhandlers}/submit_check_result \$HOSTNAME\$ '\$SERVICEDESC\$' \$SERVICESTATE\$ '\$SERVICEOUTPUT\$'",
        require => File["${icinga::params::eventhandlers}/submit_check_result"],
    }

    if $munin_enabled == true {
        file_line { "munin_nsca_sender" :
            path => "/etc/munin/munin.conf",
            line => "contacts nagios",
            ensure => $ensure,
        }

        file_line { "munin_nsca_sender_command" :
            file => "/etc/munin/munin.conf",
            line => "contact.nagios.command /usr/sbin/send_nsca -H ${nsca_receiver} -to 60 -c /etc/send_nsca.cfg",
            ensure => $ensure,
        }
    }
}
