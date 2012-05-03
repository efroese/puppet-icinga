class icinga::client { 

    if ! defined(Class['Icinga::Params']) {
        class { 'icinga::params': }
    }

}
