#
# = Class: icinga::nrpe_command
# Represents an nagios NRPE command configuration. This is defined on the client node.
#
# = Parameters:
# $command_line:: The command to run on the NRPE client
#
# $sudo:: Whether or not to use sudo 
#
# = Sample Usage:
#
# icinga::nrpe_command { 'check_mysql':
#     command_line => '$USER1$/check_mysql',
# }
#
define icinga::nrpe_command ($command_name = "",
    $command_line,
    $ensure = "present",
    $sudo = false) {
    $cmd_real = $command_name ? {
        "" => $name,
        default => $command_name,
    }
    $sudobin = $kernel ? {
        "FreeBSD" => "/usr/local/bin/sudo",
        default => "/usr/bin/sudo",
    }

    if $sudo == true {
        sudoers { "icinga::sudo_${hostname}_${cmd_real}":
            hosts => "ALL",
            users => "nagios",
            commands => " NOPASSWD: ${command_line}",
            ensure => $ensure,
        }
    }

    $command_line_real = $sudo ? {
        "true" => "${sudobin} ${command_line}",
        default => "${command_line}"
    }

    $nrpe_d = $operatingsystem ? {
        "FreeBSD" => "/usr/local/etc/nrpe.d",
        "Darwin" => "/opt/local/etc/nrpe/nrpe.d",
        /CentOS|RedHat|Amazon/ => '/etc/nrpe.d',
        default => "/etc/nagios/nrpe.d",
    }

    if ($command_line_real != "") {
        file { "${nrpe_d}/${name}.cfg" :
            content => "command[${cmd_real}]=${command_line_real}\n",
            ensure => $ensure,
        }
    }
}