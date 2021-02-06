# Class: nginx_test
# ===========================
#
# Full description of class nginx_test here.
#
# Parameters
# ----------
#
# * provide_apache (Boolean)
#   When false the apache base class is not included and need to be defined else
#
# Variables
# ----------
#
#
# Examples
# --------
#
# @example
#    class { 'webapp':
#
#    }
#
# Authors
# -------
#
# Sergio Sans  <seavba@gmail.com>
#

class webapp(
   $appdirs=lookup('files',undef,undef,undef),
   $php_file = undef,
  ){

  #Install nginx package and start the service
  include nginx

  if $appdirs {
    create_resources(file, $appdirs)
  }


  file { $php_file:
    ensure => present,
    source => 'puppet:///modules/webapp/index.php',
  }

#Install php for the app
  class { '::php':
    ensure       => latest,
    manage_repos => true,
  }
}
