#
# = Class: icinga::nrpe_service
# An icinga service that checks via NRPE
#
# = Parameters:
# See http://nagios.sourceforge.net/docs/3_0/objectdefinitions.html#service
#
# = Sample Usage:
#
# icinga::nrpe_service { 'check_nrpe_mysql':
#     icinga_tags => 'icinga_active_icinga-master.example.com',
# }
#
define icinga::nrpe_service ($host_name = $::fqdn,
    $service_description,
    $servicegroups = "",
    $is_volatile = "",
    $command_name = "",
    $command_line,
    $max_check_attempts = "5",
    $normal_check_interval = "30",
    $retry_check_interval = "15",
    $active_checks_enabled = "",
    $passive_checks_enabled = "",
    $check_period = "24x7",
    $parallelize_check = "1",
    $obsess_over_service = "",
    $check_freshness = "",
    $freshness_threshold = "",
    $event_handler = "",
    $event_handler_enabled = "",
    $low_flap_threshold = "",
    $high_flap_threshold = "",
    $flap_detection_enabled = "",
    $process_perf_data = "",
    $retain_status_information = "",
    $retain_nonstatus_information = "",
    $notification_interval = "120",
    $notification_period = "24x7",
    $notification_options = "w,u,c",
    $notifications_enabled = "1",
    $contact_groups = "",
    $stalking_options = "",
    $dependent_service_description = "",
    $inherits_parent = "1",
    $execution_failure_criteria = "w,u,c,p",
    $notification_failure_criteria = "w,u,c,p",
    $multiple_values_array = "",
    $multiple_insertin = "",
    $ensure = "present",
    $sudo = false,
    $icinga_tags = "") {
    $cmd_real = $command_name ? {
        "" => $name,
        default => $command_name,
    }
    icinga::nrpe_command {
        "icinga::nrpe_${command_name}_${host_name}" :
            command_name => $cmd_real,
            command_line => $command_line,
            ensure => $ensure,
            tag => "icinga",
            sudo => $sudo,
    }
    icinga::service {
        "icinga::${cmd_real}_${host_name}" :
            host_name => $host_name,
            service_description => $service_description,
            servicegroups => $servicegroups,
            is_volatile => $is_volatile,
            check_command => "check_nrpe!${cmd_real}",
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
            dependent_service_description => $dependent_service_description,
            inherits_parent => $inherits_parent,
            execution_failure_criteria => $execution_failure_criteria,
            notification_failure_criteria => $notification_failure_criteria,
            multiple_values_array => $multiple_values_array,
            multiple_insertin => $multiple_insertin,
            icinga_tags => $icinga_tags,
            ensure => $ensure,
    }
}
