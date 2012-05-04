#$Id$
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
