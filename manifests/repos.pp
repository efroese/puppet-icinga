class icinga::repos {
    case $::operatingsystem {
        RedHat,CentOS,Amazon : {

            package { "rpmforge-release-0.5.2-2.el6.rf.${::architecture}":
                ensure => installed,
                source => "http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.2-2.el6.rf.${::architecture}.rpm",
                provider => 'rpm',
            }

        }
    }
}
