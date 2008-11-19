#$Id$

define nagios2_command (
		$command_name="",
		$command_line,
		$ensure = "present"
		)
{
	$cmd_real = $command_name ? {
		"" => $name,
		default => $command_name,
	}
	nagios2file { "command_${cmd_real}":
		content => template("nagios/command.erb"),
		ensure =>$ensure,
	}

}

define nagios2_nrpe_command (
		$command_name="",
		$command_line,
		$ensure = "present",
		$sudo = false
		)
{
	$cmd_real = $command_name ? {
		"" => $name,
		default => $command_name,
	}
	$sudobin = $kernel ? {
	  "freebsd" => "/usr/local/bin/sudo",
	  default => "/usr/bin/sudo",
	}
	case $sudo {
		true: {
			sudo::sudoer{"nagios_sudo_${hostname}_${cmd_real}":
				user => "nagios",
				host_name => $hostname,
				command => "NOPASSWD: ${command_line}",
				ensure => $ensure,
			}
			$command_line_real = "${sudobin} ${command_line}"
		}
		false:{
			$command_line_real = $command_line
		}
	}
	$nagioscfg = $operatingsystem ? {
		"debian" =>"/etc/nagios/nrpe_local.cfg",
			"freebsd" => "/usr/local/etc/nrpe_local.cfg",
	}
	line { "nagios_nrpe_${name}":
		file => "${nagioscfg}",
		     line => "command[${cmd_real}]=${command_line_real}",
		     ensure => $ensure,
	}
}
