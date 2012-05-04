
define icinga::timeperiod (
    $timeperiod_alias,
    $includes = {},
    $exceptions = {},
    $excludes = []) {

    icinga::object { "timeperiod_${service_description}_${name}" :
        ensure => $ensure,
        content => template('icinga/timeperiod.erb'),
        tag    => 'icinga_basic_object',
    }
}
