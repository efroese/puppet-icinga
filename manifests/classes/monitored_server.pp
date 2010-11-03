# $Id$

class nagios::monitored::server inherits nagios::monitored::common {
# define this host for nagios
  nagios2_host { $fqdn:
    hostgroups => "${domain},${operatingsystem},${virtual},${architecture}",
  }
}

class nagios::monitored::server::nrpe inherits nagios::monitored::server{
  tag("nagios")
    $nrpe_service = $operatingsystem ? {
      "FreeBSD" => "nrpe2",
	"Darwin" => "org.macports.nrpe",
	default =>"nagios-nrpe-server",
    }
  $nrpe_package = $operatingsystem ? {
    "FreeBSD" => "nrpe2",
      "Darwin" => "nrpe",
      default =>"nagios-nrpe-server",
  }
  $nagios_user = $operatingsystem ? {
    "Darwin" => "daemon",
      default =>"nagios",
  }
  $nagios_group = $operatingsystem ? {
    "Darwin" => "daemon",
      default => "nagios",
  }
  $nagiosconf = $operatingsystem ? {
    "FreeBSD" => "/usr/local/etc/nagios",
      "Darwin" => "/opt/local/etc/nrpe",
      default =>"/etc/nagios",
  }

  $nrpebin = $operatingsystem ? {
    "FreeBSD" => "/usr/local/sbin/nrpe2",
      "Darwin" => "/opt/local/sbin/nrpe",
      default =>"/usr/sbin/nrpe",
  }
  $nagiosplugins = $operatingsystem ? {
    "FreeBSD" => "/usr/local/libexec/nagios",
      "Darwin" => "/opt/local/libexec/nagios",
      default =>"/usr/lib/nagios/plugins",
  }
  $nrpecfg =  $operatingsystem ? {
    "FreeBSD" => "/usr/local/etc/nrpe.cfg",
      "Darwin" => "/opt/local/etc/nrpe/nrpe.cfg",
      default =>"/etc/nagios/nrpe.cfg",
  }
  $nrpecfg_local =  $operatingsystem ? {
    "FreeBSD" => "/usr/local/etc/nrpe_local.cfg",
      "Darwin" => "/opt/local/etc/nrpe/nrpe_local.cfg",
      default =>"/etc/nagios/nrpe_local.cfg",
  }
  file{"${nrpecfg}":
    content => template("nagios/nrpe.cfg.erb"),
  }
  file{"${nrpecfg_local}": }

  if $kernel == "Darwin"{
    Package { 
      provider => "darwinport",
    }
}
package{ $nrpe_package:
  ensure => installed,
}

case $operatingsystem {
  "Debian","Ubuntu": {
    package{ [ "nagios-plugins", "nagios-plugins-basic" ]:
      ensure => installed,
    }
  }
  "Darwin": {
    package{"nagios-plugins":
      ensure => installed,
    }
  }
}
file{"${nagiosconf}/nrpe.d":
  ensure => "directory",
	 owner => $nagios_user,
	 group => $nagios_group,
}
service{ $nrpe_service:
  ensure => $kernel ? {
    "Darwin" => running,
      default => stopped
  },
	 enable => $kernel ? {
	   "Darwin" => true,
	   default => false
	 },
	 hasrestart => false,
	 pattern => "nrpe",
	 require => Package["${nrpe_package}"],
	 subscribe => [ File["${nagiosconf}/nrpe.d"], File["${nrpecfg}"], File["${nrpecfg_local}"] ],
}
case $kernel {
  "Darwin": {
    debug ("not for darwin")
  }
  default: {
	     xinetd::service{"nrpe":
	       server => "${nrpebin}",
		      server_args => "-c ${nrpecfg} --inetd",
		      user  => "nagios",
		      only_from => "127.0.0.1 ${NAGIOS_HOST}",
		      port => 5666,
	     }      
	   }
}
#add apt nrpe service
nagios2_nrpe_plugin { "${fqdn}_check_nfs_stale":
  command_name => "check_nfs_stale",
	       service_description => "NFS_STALE",
	       notification_period => "workhours",
	       notification_options => "w,c,u",
	       ensure => $kernel ? {
		 "FreeBSD" => "absent",
		 default => "present"
	       }
}
$swap_present = $swapsize ? {
  "0.00 kB" => "absent",
    "" => "absent",
    default => $presence ? {
      "absent" => "absent",
      default => "present"
    }
}
nagios2_nrpe_service { "${fqdn}_nrpe_swap":
  command_name => "check_swap",
	       command_line  => "${nagiosplugins}/check_swap -w 3% -c 1%",
	       service_description => "SWAP",
	       notification_options => "w,c,u",
	       servicegroups => "Harddrives,Memory",
	       ensure => $swap_present
}
nagios2_nrpe_service { "${fqdn}_check_diskspace":
  command_name => "check_diskspace",
	       command_line  => "${nagiosplugins}/check_disk -l -X devfs -X linprocfs -X devpts -X tmpfs -X usbfs -X procfs -X proc -X sysfs -X iso9660 -X debugfs -X binfmt_misc -X udf -X devtmpfs -X securityfs -X fusectl -w 10% -c 5%",
	       service_description => "DISKSPACE",
	       notification_period => "workhours",
	       notification_interval => "1440",
	       servicegroups => "Harddrives",
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
	       command_line => "${nagiosplugins}/check_procs -w 500 -c 900",
	       service_description => "RUNNING_PROCS",
	       notification_period => "workhours",
	       notification_options => "w,c,u",
}
nagios2_service { "${fqdn}_nrpe_zombie_processes":
  service_description => "ZOMBIE_PROCS",
		      check_command => "check_nrpe_1arg!check_zombie_procs",
		      notification_period => "workhours",
}
$processorcount_real = $kernel ? {
  "Darwin" => $sp_number_processors,
    default => $processorcount ? {
      "" => 1,
      default => $processorcount,
    }
}
$crit_one = max(times($processorcount_real, "5.5"), "10")
$crit_five = max(times($processorcount_real, "5"),"15")
$crit_fifteen = max(times($processorcount_real, "4.5"),"20")

$warn_one = max(times($processorcount_real, "3.5"), "8")
$warn_five = max(times($processorcount_real, "3.0"), "9")
$warn_fifteen = max(times($processorcount_real, "2.5"), "10")
nagios2_nrpe_service { "${fqdn}_nrpe_load":
  service_description => "LOAD",
		      command_name => "check_load",
		      command_line => "${nagiosplugins}/check_load -w ${warn_one},${warn_five},${warn_fifteen} -c ${crit_one},${crit_five},${crit_fifteen}",
		      notification_options => "w,c,u",
		      ensure => "absent",
}
}

