# $Id$

class nagios::check::nfs::common {

  nagios2_service {"${fqdn}_rpc_status":
    service_description => "RPC_STATUS",
			check_command => "check-rpc!status",
  }
  nagios2_service {"${fqdn}_rpc_status-tcp":
    service_description => "RPC_STATUSTCP",
			check_command => "check-rpc-tcp!status",
  }
  nagios2_service {"${fqdn}_rpc_portmap":
    service_description => "RPC_PORTMAP",
			check_command => "check-rpc!portmap",
  }
  nagios2_service {"${fqdn}_rpc_portmap-tcp":
    service_description => "RPC_PORTMAPTCP",
			check_command => "check-rpc-tcp!portmap",
  }
}


class nagios::check::nfs inherits nagios::check::nfs::common{

  nagios2_service {"${fqdn}_rpc":
    service_description => "RPC_NFS",
			check_command => "check-nfsv4",
  }
  nagios2_service {"${fqdn}_rpc-tcp":
    service_description => "RPC_NFSTCP",
			check_command => "check-nfsv4-tcp",
  }
  nagios2_service {"${fqdn}_rpc-nlockmgr":
    service_description => "RPC_NLOCKMGR",
			check_command => "check-rpc-version!nlockmgr!1,3,4",
  }
  nagios2_service {"${fqdn}_rpc-nlockmgr-tcp":
    service_description => "RPC_NLOCKMGRTCP",
			check_command => "check-rpc-version-tcp!nlockmgr!1,3,4",
  }
}

class nagios::check::nfs::quota inherits nagios::check::nfs {

  nagios2_service {"${fqdn}_rpc_quota":
    service_description => "RPC_NFSQUOTA",
			check_command => "check-rpc!quota",
  }
  nagios2_service {"${fqdn}_rpc_quota-tcp":
    service_description => "RPC_NFSQUOTATCP",
			check_command => "check-rpc-tcp!quota",
  }
}

class nagios::check::nfs::none inherits nagios::check::nfs::common::none {

  nagios2_service {"${fqdn}_rpc_quota":
    service_description => "RPC_NFSQUOTA",
			check_command => "check-rpc!quota",
			ensure => absent,
  }
  nagios2_service {"${fqdn}_rpc_quota-tcp":
    service_description => "RPC_NFSQUOTATCP",
			check_command => "check-rpc-tcp!quota",
			ensure => absent,
  }
  nagios2_service {"${fqdn}_rpc":
    service_description => "RPC_NFS",
			check_command => "check-nfsv4",
			ensure => absent,
  }
  nagios2_service {"${fqdn}_rpc-tcp":
    service_description => "RPC_NFSTCP",
			check_command => "check-nfsv4-tcp",
			ensure => absent,
  }
  nagios2_service {"${fqdn}_rpc-nlockmgr":
    service_description => "RPC_NLOCKMGR",
			check_command => "check-rpc!nlockmgr",
			ensure => absent,
  }
  nagios2_service {"${fqdn}_rpc-nlockmgr-tcp":
    service_description => "RPC_NLOCKMGRTCP",
			check_command => "check-rpc-tcp!nlockmgr",
			ensure => absent,
  }

}


class nagios::check::nfs::common::none {

  nagios2_service {"${fqdn}_rpc_status":
    service_description => "RPC_STATUS",
			check_command => "check-rpc!status",
			ensure => absent,
  }
  nagios2_service {"${fqdn}_rpc_status-tcp":
    service_description => "RPC_STATUSTCP",
			check_command => "check-rpc-tcp!status",
			ensure => absent,
  }
  nagios2_service {"${fqdn}_rpc_portmap":
    service_description => "RPC_PORTMAP",
			check_command => "check-rpc!portmap",
			ensure => absent,
  }
  nagios2_service {"${fqdn}_rpc_portmap-tcp":
    service_description => "RPC_PORTMAPTCP",
			check_command => "check-rpc-tcp!portmap",
			ensure => absent,
  }
}
