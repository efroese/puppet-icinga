#$Id$

#define contact{
#  contact_name                    jdoe
#  alias                           John Doe
#  service_notification_period     24x7
#  host_notification_period        24x7
#  service_notification_options    w,u,c,r
#  host_notification_options       d,u,r
#  service_notification_commands   notify-service-by-email
#  host_notification_commands      notify-host-by-email
# email       jdoe@localhost.localdomain
# pager       555-5555@pagergateway.localhost.localdomain
#  address1      xxxxx.xyyy@icq.com
#  address2      555-555-5555
#  }
define nagios2_contact (
    $contact_name="",
    $contact_alias,
    $service_notification_period = "24x7",
    $host_notification_period = "24x7",
    $service_notification_options = "w,u,c,r",
    $host_notification_options = "d,u,r",
    $service_notification_commands = "notify-service-by-email",
    $host_notification_commands = "notify-host-by-email",
    $email,
    $pager = "",
    $contact_groups = "",
    $ensure = "present"
    )
{
  $contact_name_real = $contact_name ?{
    "" => $name,
    default => $contact_name
  }
  @@nagios2file { "contact_${contact_name_real}":
    content => template("nagios/contact.erb"),
    ensure =>$ensure,
  }

}

#define contactgroup{
# contactgroup_name contactgroup_name
#  alias alias
# members members
# }

define nagios2_contactgroup (
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
  @@nagios2file { "contactgroup_${contactgroup_name_real}":
    content => template("nagios/contactgroup.erb"),
    ensure =>$ensure,
  }
}
