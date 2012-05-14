#
# = Class: icinga::servicegroup
# Represents an icinga/nagios servicegroup object.
#
# = Parameters:
# See http://nagios.sourceforge.net/docs/3_0/objectdefinitions.html#servicegroup
#
# = Sample Usage:
#
# icinga::servicegroup { 'dbservices':
#     servicegroup_alias => 'Database Services',
# }
#
define icinga::servicegroup (
    $servicegroup_name="",
    $servicegroup_alias="",
    $servicegroup_members="",
    $ensure="present"
    ){

    $servicegroup_name_real = $servicegroup_name ? {
        "" => $name,
        default => $servicegroup_name,
    }

    icinga::object { "servicegroup_${servicegroup_name_real}":
        content => template("icinga/servicegroup.erb"),
        ensure => $ensure,
        tag    => 'icinga_basic_object',
    }
}
