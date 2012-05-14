#
# = Class: icinga::hostgroup
# Represents an icinga/nagios hostgroup object.
#
# = Parameters:
# See http://nagios.sourceforge.net/docs/3_0/objectdefinitions.html#hostgroup
#
# = Sample Usage:
#
# icinga::hostgroup { 'web-servers':
#     hostgroup_alias => 'Web Servers',
# }
#
define icinga::hostgroup (
    $hostgroup_name="",
    $hostgroup_alias="",
    $members="",
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

  debug("${hostname} has hostgroup: ${hostgroup_name_real} ${ensure}")

  icinga::object { "hostgroup_${hostgroup_name_real}":
    content => template("icinga/hostgroup.erb"),
    ensure  => $ensure,
    tag     => 'icinga_basic_object',
  }
}