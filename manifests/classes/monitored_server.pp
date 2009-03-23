# $Id$

class nagios::monitored::server {
# define this host for nagios
  nagios2_host { $fqdn:
    hostgroups => "${domain},${operatingsystem},${virtual}",
  }
  nagios2_service { "${fqdn}_ssh":
    service_description => "SSH",
			check_command => "check_ssh",
			notification_period => "workhours",
  }
  nagios2_service { "${fqdn}_ping":
    service_description => "PING",
			check_command => "check_ping!125.0,20%!500.0,60%",
  }
}

class nagios::monitored::server::nrpe inherits nagios::monitored::server{
  tag("nagios")
    $nrpe_service = $operatingsystem ? {
      "FreeBSD" => "nrpe2",
	default =>"nagios-nrpe-server",
    }
  $nagiosconf = $operatingsystem ? {
    "FreeBSD" => "/usr/local/etc/nagios",
      default =>"/etc/nagios",
  }

  $nrpebin = $operatingsystem ? {
    "FreeBSD" => "/usr/local/sbin/nrpe2",
      default =>"/usr/sbin/nrpe",
  }
  $nagiosplugins = $operatingsystem ? {
    "FreeBSD" => "/usr/local/libexec/nagios",
      default =>"/usr/lib/nagios/plugins",
  }
  $nrpecfg =  $operatingsystem ? {
    "FreeBSD" => "/usr/local/etc/nrpe.cfg",
      default =>"/etc/nagios/nrpe.cfg",
  }
  package{ $nrpe_service:
    ensure => installed,
  }

  case $operatingsystem {
    "Debian","Ubuntu": {
      package{ [ "nagios-plugins", "nagios-plugins-basic" ]:
	ensure => installed,
      }
    }
  }
  file{"${nagiosconf}/nrpe.d":
    ensure => "directory",
	   owner => "nagios",
	   group => "nagios",
  }
  service{ $nrpe_service:
    ensure => stopped,
	   enable => false,
	   hasrestart => false,
	   pattern => "nrpe",
	   require => Package["${nrpe_service}"],
  }

  xinetd::service{"nrpe":
    server => "${nrpebin}",
	   server_args => "-c ${nrpecfg} --inetd",
	   user  => "nagios",
	   only_from => "127.0.0.1 ${NAGIOS_HOST}",
	   port => 5666,
  }
#add apt nrpe service
  nagios2_nrpe_plugin { "${fqdn}_check_nfs_stale":
    command_name => "check_nfs_stale",
		 command_line => "${nagiosplugins}/check_nfs_stale",
		 service_description => "NFS_STALE",
		 notification_period => "workhours",
		 notification_options => "w,c,u",
  }

  case $operatingsystem {
    "Debian","Ubuntu": {
      nagios2_nrpe_service { "${fqdn}_nrpe_apt":
	command_name => "check_apt",
		     command_line => "${nagiosplugins}/check_apt",
		     service_description => "APT",
		     normal_check_interval => "1440",
		     notification_interval => "50400",
		     notification_period => "workhours",
		     notification_options => "w,c,u",
      }
      nagios2_nrpe_service { "${fqdn}_nrpe_mailq":
	command_name => "check_mailq",
		     command_line => "${nagiosplugins}/check_mailq -w 10 -c 20 -M exim",
		     service_description => "EXIM_MAILQ",
		     notification_options => "w,c,u",
		     sudo => true,
		     ensure => absent,
      }

    }

    "FreeBSD": {
      nagios2_nrpe_service { "${fqdn}_nrpe_apt":
	command_name => "check_apt",
		     command_line => "${nagiosplugins}/check_apt",
		     service_description => "APT",
		     normal_check_interval => "1440",
		     notification_interval => "50400",
		     notification_period => "workhours",
		     notification_options => "w,c,u",
		     ensure => absent,
      }
      nagios2_nrpe_service { "${fqdn}_nrpe_mailq":
	command_name => "check_mailq",
		     command_line => "${nagiosplugins}/check_mailq -w 10 -c 20 -M exim",
		     service_description => "EXIM_MAILQ",
		     notification_options => "w,c,u",
		     sudo => true,
		     ensure => absent,
      }

    }
  }

  nagios2_nrpe_service { "${fqdn}_nrpe_swap":
    command_name => "check_swap",
		 command_line  => "${nagiosplugins}/check_swap -w 10% -c 2%",
		 service_description => "SWAP",
		 notification_options => "w,c,u",
  }
  nagios2_nrpe_service { "${fqdn}_check_diskspace":
    command_name => "check_diskspace",
		 command_line  => "${nagiosplugins}/check_disk -l -X devfs -X linprocfs -X devpts -X tmpfs -X usbfs -X proc -X sysfs -w 10% -c 5%",
		 service_description => "DISKSPACE",
		 notification_period => "workhours",
  }

  nagios2_service { "${fqdn}_nrpe_users":
    service_description => "LOGGEDIN_USERS",
			check_command => "check_nrpe_1arg!check_users",
			notifications_enabled => "1",
			notification_period => "workhours",
			notification_options => "w,c,u",
  }
  nagios2_nrpe_service { "${fqdn}_nrpe_processes":
    command_name => "check_procs",
		 command_line => "${nagiosplugins}/check_procs -w 200 -c 250",
		 service_description => "RUNNING_PROCS",
		 notification_period => "workhours",
		 notification_options => "w,c,u",
  }
  nagios2_service { "${fqdn}_nrpe_zombie_processes":
    service_description => "ZOMBIE_PROCS",
			check_command => "check_nrpe_1arg!check_zombie_procs",
			notification_period => "workhours",
  }
  $crit_one = max(times($processorcount, "5.5"), "10")
    $crit_five = max(times($processorcount, "5"),"15")
    $crit_fifteen = max(times($processorcount, "4.5"),"20")

    $warn_one = max(times($processorcount, "3.5"), "8")
    $warn_five = max(times($processorcount, "3.0"), "9")
    $warn_fifteen = max(times($processorcount, "2.5"), "10")
    nagios2_nrpe_service { "${fqdn}_nrpe_load":
      service_description => "LOAD",
			  command_name => "check_load",
			  command_line => "${nagiosplugins}/check_load -w ${warn_one},${warn_five},${warn_fifteen} -c ${crit_one},${crit_five},${crit_fifteen}",
			  notification_options => "w,c,u",
    }
}

