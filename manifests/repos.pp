class icinga::repos {
    case $::operatingsystem {
        RedHat,CentOS,Amazon : {

            package { "rpmforge-release-0.5.2-2.el6.rf.${::architecture}":
                ensure => installed,
                source => "http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.2-2.el6.rf.${::architecture}.rpm",
                provider => 'rpm',
            }

            package { 'remi-release-6':
                ensure => installed,
                source => 'http://rpms.famillecollet.com/enterprise/remi-release-6.rpm',
                provider => 'rpm',
            }
        }
    }
}
