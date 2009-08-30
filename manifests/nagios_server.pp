# $Id$

class nagios::server{
  include nagios::nsca::receiver::none
    package { ["nagios3",
      "nagios-images",
      "nagios-nrpe-plugin",
      "nagios3-common",
      "nagios-plugins-standard" ]: ensure => present 
    }

  nagios2_service { "${fqdn}_mem_percent_nagios":
              service_description => "mem_percent_nagios",
                check_command => "check_ganglia!mem_percent_nagios!70!90",
                servicegroups => "Memory",
                notification_options => "c,u",
            } 

  service{ "nagios3":
    ensure => running,
    require => Package["nagios3"],
    subscribe => File[$NAGIOSCONFDIR],
  }
  #munin::remoteplugin{ ["nagios-hosts", "nagios-services", "nagios-hosts-checks", "nagios-latencies", "nagios-state-changes"]: 
  #  ensure => "present",
  #  source => "nagios/munin",
  #  config => "[nagios-*]\nuser root\n",
  #}
#collect all nagios_ definitions

  File <<| tag == "nagios" |>>

    file { $NAGIOSCONFDIR:
      ensure => directory,
	     require => Package["nagios3"],
    }
  file { [ "${NAGIOSCONFDIR}/localhost_nagios3.cfg",
    "${NAGIOSCONFDIR}/hostgroups_nagios3.cfg",
    "${NAGIOSCONFDIR}/extinfo_nagios3.cfg" ]:
      ensure  => absent,
    notify  => Service["nagios3"],
    tag => "nagios",
  }
  remotefile {"${NAGIOSCONFDIR}/timeperiods_nagios3.cfg":
    ensure => present,
    source => "timeperiods_nagios3.cfg",
    module => "nagios",
    mode=> "0644",
    notify => Service["nagios3"],
  }

##some additional commands
  nagios2_command{"check-nfsv4":
    command_line => "/usr/lib/nagios/plugins/check_rpc -H \$HOSTADDRESS\$ -C nfs -c2,3,4",
  }
  nagios2_command{"check-nfsv4-tcp":
    command_line => "/usr/lib/nagios/plugins/check_rpc -H \$HOSTADDRESS\$ -C nfs -t -c2,3,4",
  }
  nagios2_command{"check-nfsv3":
    command_line => "/usr/lib/nagios/plugins/check_rpc -H \$HOSTADDRESS\$ -C nfs -c2,3",
  }
  nagios2_command{"check-nfsv3-tcp":
    command_line => "/usr/lib/nagios/plugins/check_rpc -H \$HOSTADDRESS\$ -C nfs -t -c2,3",
  }

  
  nagios2_command{"check-rpc-tcp":
    command_line => "/usr/lib/nagios/plugins/check_rpc -H \$HOSTADDRESS\$ -C \$ARG1\$ -t",
  }
  nagios2_command{"check-rpc-version":
    command_line => "/usr/lib/nagios/plugins/check_rpc -H \$HOSTADDRESS\$ -C \$ARG1\$ -c \$ARG2\$",
  }
  nagios2_command{"check-rpc-version-tcp":
    command_line => "/usr/lib/nagios/plugins/check_rpc -H \$HOSTADDRESS\$ -t -C \$ARG1\$ -c \$ARG2\$",
  }
# default host groups
  nagios2_hostgroup{["Debian","Ubuntu","FreeBSD","Darwin"]: }
  nagios2_hostgroup{["Physical","Xenu","Xen0"]: }
  nagios2_hostgroup{["ppc","amd64","i386","x86_64"]: }
  $nagiosplugins = $operatingsystem ? {
      "FreeBSD" => "/usr/local/libexec/nagios",
      default =>"/usr/lib/nagios/plugins",
    }
  file{"${nagiosplugins}/check_ganglia":
    source => "puppet:///ganglia/contrib/check_ganglia",
      mode => 0755,
   }  
}


class nagios::nsca::receiver {
  $presence_real = $nsca_presence ? {
    "absent" => "absent",
      default => "present"
  }
  notice("NSCA should be \"${presence_real}\"")

    package { "nsca": ensure => $presence_real }
  service { "nsca": ensure =>"stopped", require => Package["nsca"], }
  xinetd::service{"nsca":
    server => "/usr/sbin/nsca",
	   server_args => "-c /etc/nsca.cfg --inetd",
	   user  => "nagios",
	   group => "nagios",
	   only_from => "127.0.0.1 munin.ikw.Uni-Osnabrueck.DE",
	   port => 5667,
	   ensure => $presence_real,
  }
  nagios2_service{ "${fqdn}_nsca_receiver":
    service_description => "nsca",
			check_command => "check_tcp!5667",
			ensure => $presence_real,
  }
  nagios2_command {"dummy_command_for_nsca":
    command_name => "check_dummy",
		 command_line => "/usr/lib/nagios/plugins/check_dummy \$ARG1\$ \$ARG2\$",
		 ensure => "present",
  }
}

class nagios::nsca::receiver::none {
  $nsca_presence = "absent"
    include nagios::nsca::receiver
}

class nagios::nsca::sender::none {
  $nsca_presence = "absent"
    include nagios::nsca::sender
}


class nagios::nsca::sender {
  $presence_real = $nsca_presence ? {
    "absent" => "absent",
      default => "present"
  }
  package { "nsca": ensure => $presence_real }

  service { "nsca": ensure => "stopped", require => Package["nsca"], }
  line{"munin_nsca_sender":
    file => "/etc/munin/munin.conf",
	 line => "contacts nagios",
	 ensure => $presence_real,
  }
  line{"munin_nsca_sender_command":
    file => "/etc/munin/munin.conf",
	 line => "contact.nagios.command /usr/sbin/send_nsca -H ${NAGIOS_HOST} -to 60 -c /etc/send_nsca.cfg",
	 ensure => $presence_real,
  }
}
