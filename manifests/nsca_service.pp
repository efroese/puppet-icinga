#
# = Define icinga::nsca_service
# Export a file representing a passive service check submitted to a central
# server via NSCA.
#
# == Parameters
# Most of the paramaters are taken right from the nagios/icinga
# object definitions. Refer to the docs for their meanings.
#
# $tags:: If you tag an object with icinga_passive_${::fqdn} then only the
#   icinga server at ${::fqdn} will store a passive service check
#   You can also pass other arbitrary tags in an array.
#
define icinga::nsca_service ($host_name = $::fqdn,
    $service_description,
    $servicegroups = "",
    $is_volatile = "1",
    $check_command = "check_dummy!3!'No check result received'",
    $max_check_attempts = "1",
    $normal_check_interval = "30",
    $retry_check_interval = "15",
    $active_checks_enabled = "1",
    $passive_checks_enabled = "1",
    $parallelize_check = "1",
    $obsess_over_service = "",
    $freshness_threshold = "",
    $event_handler = "",
    $event_handler_enabled = "1",
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
    $icinga_tags = "",
    $ensure = "present") {
    icinga::service {
        "icinga::nsca_${service_description}_${host_name}" :
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
