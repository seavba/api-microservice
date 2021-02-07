# Class: nginx_test
# ===========================
# Class for installing a NGINX server (with PHP support) in a Centos server. Over the NGINX, a php application runs providing a json response (like an API function). NGINX is redirecting from http to https and then proxying the API call "hello" to the backend vhost. 
#
# Parameters
# ----------
# Not used.
#
# Variables
# ----------
# All variables are declared in the yaml. Please don't do it in the manifest.
#
# $appdirs = Hiera hash for creating custom directories needed for the web application.
# $php_file = Web appplication wrote in PHP.
# $certs_dir = Direcory used for saving the SSL certificates
#
# Author
# -------
# Sergio Sans  <seavba@gmail.com>
#

class webapp(
   $appdirs=lookup('files',undef,undef,undef),
   $php_file = undef,
   $certs_dir=undef,
  ){

  #Install nginx and openssl packages and start the service
  include nginx
  include openssl

  #Install php for running the app
  class { '::php::globals':
    php_version => '7.0',
  }

  class { '::php':
    ensure       => latest,
    manage_repos => true,
    fpm          => true,
  }

  #Create custom directories for web application
  if $appdirs {
    create_resources(file, $appdirs)
  }

  #Upload webapp file
  file { $php_file:
    ensure => present,
    source => 'puppet:///modules/webapp/index.php',
  }

#Crete SSL certificates and key
  openssl::certificate::x509 { "webapp":
      ensure        => 'present',
      country       => 'ES',
      state         => 'CAT',
      locality      => 'BCN',
      organization  => 'MYORG',
      unit          => 'IT',
      commonname    => 'webapp.com',
      email         => 'it@myorg.com',
      days          => 730,
      base_dir      => $certs_dir,
      force         => false,
      cnf_tpl      => 'openssl/cert.cnf.erb',
  }

#Allow http from outside on SELinux
  selboolean { 'httpd_can_network_connect':
    name       => 'httpd_can_network_connect',
    persistent => true,
    value      => on,
  }

}
