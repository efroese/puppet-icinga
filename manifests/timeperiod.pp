#
# = Class: icinga::timeperiod
# Represents an icinga/nagios timeperiod object.
#
# = Parameters:
# See http://nagios.sourceforge.net/docs/3_0/objectdefinitions.html#timeperiod
#
# = Sample Usage:
#
# icinga::timeperiod { '24x7':
#    timeperiod_alias => '24 Hours A Day, 7 Days A Week',
#    includes => {
#        'monday'    => '00:00-24:00',
#        'tuesday'   => '00:00-24:00',
#        'wednesday' => '00:00-24:00',
#        'thursday'  => '00:00-24:00',
#        'friday'    => '00:00-24:00',
#        'saturday'  => '00:00-24:00',
#        'sunday'    => '00:00-24:00',
#     }
# }
#
define icinga::timeperiod (
    $timeperiod_alias,
    $use = "",
    $includes = {},
    $exceptions = {},
    $excludes = []) {

    icinga::object { "timeperiod_${service_description}_${name}" :
        ensure => $ensure,
        content => template('icinga/timeperiod.erb'),
        tag    => 'icinga_basic_object',
    }
}
