# $Id$

class nagios::monitored::desktop {
# define this host for nagios
  nagios2_host { $fqdn:
    hostgroups => $domain ? {
      "ikw.Uni-Osnabrueck.DE" => "IKW,Desktops",
	"nkg.Uni-Osnabrueck.DE" => "NKG,Desktops",
	"neurobiopsychologie.Uni-Osnabrueck.DE" => "NBP,Desktops",
	"cogsci.Uni-Osnabrueck.DE" => "COGSCI,Desktops",
    },
	       notification_options => "n",
	       notification_period => "workhours",
  }
  nagios2_service { "${fqdn}_ssh":
    service_description => "SSH",
			check_command => "check_ssh",
			notification_period => "workhours",
			notification_options => "n",
  }
  nagios2_nsca_service { "${fqdn}_diskspace":
    service_description => "DISKUSAGE",
			notification_period => "workhours",
			notification_options => "n",
  }
  nagios2_nsca_service { "${fqdn}_load":
    service_description => "Load average",
			notification_period => "workhours",
			notification_options => "w,c,u",
  }
  nagios2_nsca_service { "${fqdn}_packages":
    service_description => "Pending packages",
			notification_period => "workhours",
			notification_options => "n",
  }
}
