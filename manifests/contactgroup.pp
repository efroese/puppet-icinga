#
# = Class: icinga::contactgroup
# Represents an icinga/nagios contactgroup object.
#
# = Parameters:
# See http://nagios.sourceforge.net/docs/3_0/objectdefinitions.html#contactgroup
#
# = Sample Usage:
#
# icinga::contactgroup { 'ops':
#     contactgroup_alias => 'Operations',
#     members => 'mike,vinnie,paulie',
# }
#
define icinga::contactgroup (
    $contactgroup_name="",
    $contactgroup_alias,
    $members,
    $ensure = "present"
    )
{
  $contactgroup_name_real = $contactgroup_name ?{
    "" => $name,
    default => $contactgroup_name,
  }
   icinga::object { "contactgroup_${contactgroup_name_real}":
    content => template("icinga/contactgroup.erb"),
    ensure => $ensure,
    tag    => 'icinga_basic_object',
  }
}