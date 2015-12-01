class profiles::misp {

include  profiles::linux_default 
package { 'zip': ensure => installed,}
package { 'php-pear': ensure => installed,}
package { 'make': ensure => installed,}
package { 'python-dev': ensure => installed,}
package { 'python-pip': ensure => installed,}
package { 'libxml2-dev': ensure => installed,}
package { 'libxslt-dev': ensure => installed,}
package { 'zlib1g-dev': ensure => installed,}
package { 'php5-dev': ensure => installed,}
package { 'php5-mysql': ensure => installed,}
package { 'php5-redis': ensure => installed,}

class { 'redis::install':
  redis_version  => '2:2.8.4-2',
  redis_package  => true,
}


class { 'apache': 
	mpm_module => 'prefork',
	default_vhost => false,
	log_level   => warn,
	 }

apache::mod { 'rewrite': }

apache::vhost { 'misp.local':
  vhost_name       => '*',
  port             => '80',
  docroot          => '/var/www/MISP/app/webroot',
  docroot_owner => 'www-data',
  docroot_group => 'www-data',
  directories => [
    { 'path'     => '/var/www/MISP/app/webroot',
      'provider' => 'directory',
       allow_override => 'all',
       options       => ['Indexes','FollowSymLinks'],
       order 	=> 'Allow, Deny',	
       allow     => 'from all',
     },
	],
}

include pear

pear::package {"Crypt_GPG":}
pear::package {"Net_GeoIP":}

class {'::apache::mod::php':
  package_name => "php5",
  path         => "${::apache::params::lib_path}/libphp5.so",
  content => 'AddHandler php5-script .php
	      AddType text/html .php
	      DirectoryIndex index.php'
}



class { '::mysql::server':
  root_password           => 'strongpassword',
  remove_default_accounts => true,
  override_options        => $override_options
}

mysql::db { 'misp':
  user     => 'misp',
  password => 'mypass',
  host     => 'localhost',
  sql	   => '/var/www/MISP/INSTALL/MYSQL.sql',
  subscribe => Exec[ 'git-misp' ],
#  refreshonly => true,
}

class { 'postfix': }




exec { 'git-misp':
  	command => "git clone https://github.com/MISP/MISP.git /tmp/MISP && mv /tmp/MISP /var/www/MISP",
  	path 	=> [ '/bin/', '/usr/bin/' ],
#	provider => shell,
	require => Package['git'],
	onlyif  => "test ! -d /var/www/MISP",
	}


exec { 'git-ignore file mode':
        command => "git config core.filemode false",
        path    => [ '/bin/', '/usr/bin/' ],
	cwd	=>"/var/www/MISP",
	subscribe => Exec[ 'git-misp' ],
	refreshonly => true,
        }

exec { 'git-python-cybox':
        command => "git clone https://github.com/CybOXProject/python-cybox.git /tmp/python-cybox && mv /tmp/python-cybox /var/www/MISP/app/files/scripts",
        path    => [ '/bin/', '/usr/bin/' ],
        refreshonly => true,
	}


exec { 'git-python-stix':
        command => "git clone https://github.com/STIXProject/python-stix.git /tmp/python-stix && mv /tmp/python-stix /var/www/MISP/app/files/scripts",
        path    => [ '/bin/', '/usr/bin/' ],
        refreshonly => true,
        }


exec { 'python-stix-install':
        command => "python setup.py install",
        path    => [ '/bin/', '/usr/bin/' ],
	cwd 	=> "/var/www/MISP/app/files/scripts/python-stix",
        refreshonly => true,
        }

exec { 'python-cybox-install':
        command => "python setup.py install",
        path    => [ '/bin/', '/usr/bin/' ],
        cwd     => "/var/www/MISP/app/files/scripts/python-cybox",
        refreshonly => true,
        }




Class['::apache::mod::php']~> Exec['git-misp']~> Mysql::Db['misp'] ~> Exec['git-python-cybox'] ~> Exec['git-python-stix'] ~> Exec['python-stix-install'] ~> Exec['python-cybox-install'] ~>Apache::Vhost[ 'misp.local']

}
