#
# = Class: icinga::client
# Common resources for monitored nodes
#
class icinga::client { 

    if ! defined(Class['Icinga::Params']) {
        class { 'icinga::params': }
    }

}
