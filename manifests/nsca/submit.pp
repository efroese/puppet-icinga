#
# = Class icinga::nsca::submit
# Define the submit_check_result and cubmit_host_result icinga commands
# for NSCA senders.
#
# Only ONE node should declare this class. All distributed icinga
# servers should collect this check as part of collecting all of 
# the icinga::command resources
#
class icinga::nsca::submit {

    Class['Icinga::Params'] -> Class['Icinga::Nsca::Submit']

    icinga::command { 'submit_check_result':
        ensure       => present,
        command_line => "${icinga::params::eventhandlers}/submit_check_result \$HOSTNAME\$ '\$SERVICEDESC\$' \$SERVICESTATE\$ '\$SERVICEOUTPUT\$'",
    }

    icinga::command { 'submit_host_result':
        ensure       => present,
        command_line => "${icinga::params::eventhandlers}/submit_host_result \$HOSTNAME\$ \$HOSTSTATEID\$ '\$HOSTOUTPUT\$'",
    }
}
