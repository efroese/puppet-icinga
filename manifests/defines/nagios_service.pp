# $Id$

define nagios2_service (
    $host_name="${fqdn}",
    $service_description,
    $servicegroups="",
    $is_volatile="",
    $check_command,
    $max_check_attempts="5",
    $normal_check_interval="30",
    $retry_check_interval="15",
    $active_checks_enabled="",
    $passive_checks_enabled="",
    $check_period="24x7",
    $parallelize_check="1",
    $obsess_over_service="",
    $check_freshness="",
    $freshness_threshold="",
    $event_handler="",
    $event_handler_enabled="",
    $low_flap_threshold="",
    $high_flap_threshold="",
    $flap_detection_enabled="",
    $process_perf_data="",
    $retain_status_information="",
    $retain_nonstatus_information="",
    $notification_interval="30",
    $notification_period="24x7",
    $notification_options="w,u,c",
    $notifications_enabled="1",
    $contact_groups="IKW_admins",
    $stalking_options="",
    $ensure="present"
    )
{
  $host_name_real = downcase($host_name)
    nagios2file { "service_${service_description}_${host_name_real}":
      content => template("nagios/service.erb"),
      ensure => $ensure,
    }
}


define nagios2_nsca_service (
    $host_name="${fqdn}",
    $service_description,
    $servicegroups="",
    $is_volatile="1",
    $check_command = "check_dummy!3!'No check result received'",
    $max_check_attempts="1",
    $normal_check_interval="30",
    $retry_check_interval="15",
    $active_checks_enabled="1",
    $passive_checks_enabled="1",
    $parallelize_check="1",
    $obsess_over_service="",
    $freshness_threshold="",
    $event_handler="",
    $event_handler_enabled="1",
    $low_flap_threshold="",
    $high_flap_threshold="",
    $flap_detection_enabled="",
    $process_perf_data="",
    $retain_status_information="",
    $retain_nonstatus_information="",
    $notification_interval="120",
    $notification_period="24x7",
    $notification_options="w,u,c",
    $notifications_enabled="1",
    $contact_groups="IKW_admins",
    $stalking_options="",
    $ensure="present"
    )
{
  nagios2_service{ "nagios_nsca_${service_description}_${host_name}":
    host_name => $host_name,
    service_description => $service_description,
    servicegroups => $servicegroups,
    is_volatile => $is_volatile,
    check_command => $check_command,
    max_check_attempts => $max_check_attempts,
    normal_check_interval => $normal_check_interval,
    retry_check_interval => $retry_check_interval,
    active_checks_enabled => $active_checks_enabled,
    passive_checks_enabled => $passive_checks_enabled,
    check_period => "none",
    parallelize_check => $parallelize_check,
    obsess_over_service => $obsess_over_service,
    check_freshness => "0",
    freshness_threshold => $freshness_threshold,
    event_handler => $event_handler,
    event_handler_enabled => $event_handler_enabled,
    low_flap_threshold => $low_flap_threshold,
    high_flap_threshold => $high_flap_threshold,
    flap_detection_enabled => $flap_detection_enabled,
    process_perf_data => $process_perf_data,
    retain_status_information => $retain_status_information,
    retain_nonstatus_information => $retain_nonstatus_information,
    notification_interval => $notification_interval,
    notification_period => $notification_period,
    notification_options => $notification_options,
    notifications_enabled => $notifications_enabled,
    contact_groups => $contact_groups,
    stalking_options => $stalking_options,
    ensure => $ensure,
  }

}

define nagios2_nrpe_service (
    $host_name="${fqdn}",
    $service_description,
    $servicegroups="",
    $is_volatile="",
    $command_name,
    $command_line,
    $max_check_attempts="5",
    $normal_check_interval="30",
    $retry_check_interval="15",
    $active_checks_enabled="",
    $passive_checks_enabled="",
    $check_period="24x7",
    $parallelize_check="1",
    $obsess_over_service="",
    $check_freshness="",
    $freshness_threshold="",
    $event_handler="",
    $event_handler_enabled="",
    $low_flap_threshold="",
    $high_flap_threshold="",
    $flap_detection_enabled="",
    $process_perf_data="",
    $retain_status_information="",
    $retain_nonstatus_information="",
    $notification_interval="30",
    $notification_period="24x7",
    $notification_options="w,u,c",
    $notifications_enabled="1",
    $contact_groups="IKW_admins",
    $stalking_options="",
    $ensure="present",
    $sudo = false
    )
{

  nagios2_nrpe_command{ "nagios_nrpe_${command_name}_${host_name}":
    command_name => $command_name,
    command_line  => $command_line,
    ensure => $ensure,
    tag => "nagios",
    sudo => $sudo,
  }

  nagios2_service{ "nagios_${command_name}_${host_name}":
    host_name => $host_name,
    service_description => $service_description,
    servicegroups => $servicegroups,
    is_volatile => $is_volatile,
    check_command => "check_nrpe_1arg!${command_name}",
    max_check_attempts => $max_check_attempts,
    normal_check_interval => $normal_check_interval,
    retry_check_interval => $retry_check_interval,
    active_checks_enabled => $active_checks_enabled,
    passive_checks_enabled => $passive_checks_enabled,
    check_period => $check_period,
    parallelize_check => $parallelize_check,
    obsess_over_service => $obsess_over_service,
    check_freshness => $check_freshness,
    freshness_threshold => $freshness_threshold,
    event_handler => $event_handler,
    event_handler_enabled => $event_handler_enabled,
    low_flap_threshold => $low_flap_threshold,
    high_flap_threshold => $high_flap_threshold,
    flap_detection_enabled => $flap_detection_enabled,
    process_perf_data => $process_perf_data,
    retain_status_information => $retain_status_information,
    retain_nonstatus_information => $retain_nonstatus_information,
    notification_interval => $notification_interval,
    notification_period => $notification_period,
    notification_options => $notification_options,
    notifications_enabled => $notifications_enabled,
    contact_groups => $contact_groups,
    stalking_options => $stalking_options,
    ensure => $ensure,
    tag => "nagios"
  }
}

define nagios2_nrpe_plugin (
    $host_name="${fqdn}",
    $service_description,
    $servicegroups="",
    $is_volatile="",
    $command_name,
    $command_line,
    $max_check_attempts="5",
    $normal_check_interval="30",
    $retry_check_interval="15",
    $active_checks_enabled="",
    $passive_checks_enabled="",
    $check_period="24x7",
    $parallelize_check="1",
    $obsess_over_service="",
    $check_freshness="",
    $freshness_threshold="",
    $event_handler="",
    $event_handler_enabled="",
    $low_flap_threshold="",
    $high_flap_threshold="",
    $flap_detection_enabled="",
    $process_perf_data="",
    $retain_status_information="",
    $retain_nonstatus_information="",
    $notification_interval="30",
    $notification_period="24x7",
    $notification_options="w,u,c,r",
    $notifications_enabled="1",
    $contact_groups="IKW_admins",
    $stalking_options="",
    $ensure="present",
    $sudo = false
    )
{
  $host_name_real = downcase($host_name)
    $sudobin = $kernel ? {
      "freebsd" => "/usr/local/bin/sudo",
      default => "/usr/bin/sudo",
    }

  case $sudo {
true: {
	sudo::sudoer{"nagios_${hostname}_${command_name}":
	  user => "nagios",
	  host_name => $hostname,
	  command => "NOPASSWD: ${command_line}",
	}
	$command_line_real = "${sudobin} ${command_line}"
      }
false:{
	$command_line_real = $command_line
#         sudo::sudoer{"nagios_${ensure}_${hostname}":
#            user => "nagios",
#            host_name => $hostname,
#            command => "NOPASSWD: ${command_line}",
#         ensure => absent,
#         }
      }
  }
  $nagiosplugins = $operatingsystem ? {
    "FreeBSD" => "/usr/local/libexec/nagios",
      default =>"/usr/lib/nagios/plugins",
  }
  remotefile{ "${nagiosplugins}/${command_name}":
    mode => "0755",
	 source => "plugins/${command_name}",
	 ensure => $ensure,
	 module => "nagios",
  }
  nagios2_nrpe_service{ "nagios_${command_name}_${host_name}":
    host_name => $host_name,
	      service_description => $service_description,
	      servicegroups => $servicegroups,
	      is_volatile => $is_volatile,
	      command_name => $command_name,
	      command_line  => $command_line_real,
	      max_check_attempts => $max_check_attempts,
	      normal_check_interval => $normal_check_interval,
	      retry_check_interval => $retry_check_interval,
	      active_checks_enabled => $active_checks_enabled,
	      passive_checks_enabled => $passive_checks_enabled,
	      check_period => $check_period,
	      parallelize_check => $parallelize_check,
	      obsess_over_service => $obsess_over_service,
	      check_freshness => $check_freshness,
	      freshness_threshold => $freshness_threshold,
	      event_handler => $event_handler,
	      event_handler_enabled => $event_handler_enabled,
	      low_flap_threshold => $low_flap_threshold,
	      high_flap_threshold => $high_flap_threshold,
	      flap_detection_enabled => $flap_detection_enabled,
	      process_perf_data => $process_perf_data,
	      retain_status_information => $retain_status_information,
	      retain_nonstatus_information => $retain_nonstatus_information,
	      notification_interval => $notification_interval,
	      notification_period => $notification_period,
	      notification_options => $notification_options,
	      notifications_enabled => $notifications_enabled,
	      contact_groups => $contact_groups,
	      stalking_options => $stalking_options,
	      ensure => $ensure,
  }
}
