
define icinga::timeperiod (
    $timeperiod_alias,
    $includes = {},
    $exceptions = {},
    $excludes = []) {
        
    $content = template('icinga/timeperiod.erb')
    
    icinga::object {
        "timeperiod_${service_description}_${name}" :
            content => $content,
            ensure => $ensure,
    }
}
