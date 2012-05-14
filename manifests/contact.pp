#
# = Class: icinga::contact
# Represents an icinga/nagios contact object.
#
# = Parameters:
# See http://nagios.sourceforge.net/docs/3_0/objectdefinitions.html#contact
#
define icinga::contact (
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
   icinga::object { "contact_${contact_name_real}":
    content => template("icinga/contact.erb"),
    ensure =>$ensure,
    tag    => 'icinga_basic_object',
  }

}
