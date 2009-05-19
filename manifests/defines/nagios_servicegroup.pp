# $Id$

define nagios2_servicegroup (
  $servicegroup_name="",
  $servicegroup_alias="",
  $servicegroup_members="",
  $ensure="present"
  ) 
{
  $servicegroup_name_real = $servicegroup_name ? {
    "" => $name,
      default => $servicegroup_name,
  }
    nagios2file { "servicegroup_${servicegroup_name_real}":
          content => template("nagios/servicegroup.erb"),
          ensure => $ensure,
        }
}