#
# = Class: icinga::command
# Represents an icinga/nagios command object.
#
# = Parameters:
# See http://nagios.sourceforge.net/docs/3_0/objectdefinitions.html#command
#
define icinga::command ($command_name = "",
    $command_line,
    $ensure = "present") {
    $cmd_real = $command_name ? {
        "" => $name,
        default => $command_name,
    }
    icinga::object {
        "command_${cmd_real}" :
            content => template("icinga/command.erb"),
            ensure => $ensure,
            tag    => 'icinga_basic_object',
    }
}
