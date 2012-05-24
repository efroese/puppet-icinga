#
# = Class icinga::nsca::submit
# Define the submit_check_result icinga command for NSCA senders.
# Only ONE node should declare this class. All distributed icinga
# servers should collect this check as part of collecting all of 
# the icinga::command resources
#
class icinga::nsca::submit {

    Class['Icinga::Params'] -> Class['Icinga::Nsca::Submit']

    file { "${icinga::params::eventhandlers}/submit_check_result":
        owner   => root,
        group   => root,
        mode    => 0755,
        content => template('icinga/submit_check_result.erb'),
        require => File[$icinga::params::eventhandlers],
    }

    icinga::command { 'submit_check_result':
        ensure       => present,
        command_line => "${icinga::params::eventhandlers}/submit_check_result \$HOSTNAME\$ '\$SERVICEDESC\$' \$SERVICESTATE\$ '\$SERVICEOUTPUT\$'",
        require      => File["${icinga::params::eventhandlers}/submit_check_result"],
    }
}
