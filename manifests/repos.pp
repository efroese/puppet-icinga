class icinga::repos {
    case $::operatingsystem {
        RedHat,CentOS,Amazon : {
            package { 'http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.2-2.el6.rf.i686.rpm':
                ensure => installed,
                provider => 'rpm',
            }
        }
    }
}