#
# define contactgroup {
#     contactgroup_name contactgroup_name
#     alias alias
#     members members
# }
define icinga::contactgroup (
    $contactgroup_name="",
    $contactgroup_alias,
    $members,
    $ensure = "present"
    )
{
  $contactgroup_name_real = $contactgroup_name ?{
    "" => $name,
    default => $contactgroup_name
  }
   icinga::object { "contactgroup_${contactgroup_name_real}":
    content => template("icinga/contactgroup.erb"),
    ensure =>$ensure,
  }
}