#
# = Define icinga::service
# Export an Icinga service configuration file resource
#
# == Parameters
# Most of the paramaters are taken right from the nagios/icinga
# object definitions. Refer to the docs for their meanings.
#
# $tags:: If you tag an object with icinga_active_${::fqdn} then only the
#   icinga server at ${::fqdn} will execute the active service check
#   You can also pass other arbitrary tags in an array.
#
define icinga::service ($host_name = "${fqdn}",
    $service_description,
    $servicegroups = "",
    $is_volatile = "",
    $check_command,
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
    $notification_interval = "1440",
    $notification_period = "24x7",
    $notification_options = "w,u,c",
    $notifications_enabled = "1",
    $contact_groups = "",
    $stalking_options = "",
    $dependent_service_description = "PING",
    $inherits_parent = "1",
    $execution_failure_criteria = "w,u,c,p",
    $notification_failure_criteria = "w,u,c,p",
    $multiple_values_array = "",
    $multiple_insertin = "",
    $service_template = "",
    $tags = "",
    $ensure = "present") {
    $host_name_real = downcase($host_name)
    $tmpl = $service_template ? {
        "" => "icinga/service.erb",
        default => $service_template
    }
    #notice("${hostname} has template: ${tmpl}")
    if $dependent_service_description == "" {
        $content = template("${tmpl}")
    }
    else {
        $content = template("${tmpl}", "icinga/servicedependency.erb")
    }
    icinga::object { "service_${service_description}_${name}" :
        content => $content,
        ensure => $ensure,
        tag => $tags ? {
            "" => 'icinga_object',
            default => [ 'icinga_object', $tags ],
        },
    }
}
