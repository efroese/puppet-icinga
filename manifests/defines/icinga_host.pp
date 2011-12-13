#$Id$

define nagios2_host(
    $host_name="${fqdn}",
    $host_alias="${hostname}",
    $address="${ipaddress}",
    $parents="",
    $hostgroups="",
    $check_command="check-host-alive",
    $max_check_attempts="5",
    $check_interval="",
    $active_checks_enabled="",
    $passive_checks_enabled="",
    $check_period="24x7",
    $obsess_over_host="",
    $check_freshness="",
    $freshness_threshold="",
    $event_handler="",
    $event_handler_enabled="",
    $low_flap_threshold="",
    $high_flap_threshold="",
    $flap_detection_enabled="",
    $process_perf_data="",
    $retain_status_information="",
    $retain_nonstatus_information ="",
    $contact_groups="IKW_admins",
    $notification_interval="1440",
    $notification_period="24x7",
    $notification_options="d,u,r",
    $notifications_enabled="1",
    $stalking_options="",
    $ensure = "present"
    )
{
  $host_name_real = downcase($host_name)
    if defined(Nagios2file["host_${host_name_real}"]){
      debug("already defined")
    }else{
       nagios2file { "host_${host_name_real}":
	content => template("nagios/host.erb"),
	ensure =>$ensure,
      }
    }
}


define nagios2_hostgroup (
    $hostgroup_name="",
    $hostgroup_alias="",
    $members="gateway",
    $ensure = "present"
    )
{
  $hostgroup_name_real = $hostgroup_name ? {
    "" => downcase($name),
    default => downcase($hostgroup_name)
  }

  $hostgroup_alias_real = $hostgroup_alias ? {
    "" => $hostgroup_name ? {
      "" => $name,
      default => $hostgroup_name
    },
    default => $hostgroup_alias
  }
    notify {"${hostname} has hostgroup: ${hostgroup_name_real} ${ensure}": }
  nagios2file { "hostgroup_${hostgroup_name_real}":
    content => template("nagios/hostgroup.erb"),
    ensure =>$ensure,
  }
}
