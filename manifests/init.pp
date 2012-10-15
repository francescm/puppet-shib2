class shib2 {
	case $lsbdistid {
		Debian: {
			$service_name = 'libapache2-mod-shib2'
			}
		default: { $service_name = undef }
	}

	include apache2
	info "configuring shib2 for $fqdn"

	shib_keygen()

	package { $service_name:
		ensure => installed,
		notify => Exec["enable_shib2"]
		}

	file { '/etc/shibboleth/sp-cert.pem' :
		ensure => file,
		source => "puppet:///modules/shib2/etc/shibboleth/sp-cert.pem-$hostname",
		owner => "_shibd",
		notify => Service['shibd']
		}

	file { '/etc/shibboleth/sp-key.pem' :
		ensure => file,
		source => "puppet:///modules/shib2/etc/shibboleth/sp-key.pem-$hostname",
		owner => "_shibd",
		group => "_shibd",
		mode => "640",
		notify => Service['shibd']
		}

# copy a metadata-signing certificate
#	file { '/etc/shibboleth/garrcert015e.bundle' :
#		ensure => file,
#		source => "puppet:///modules/shib2/etc/shibboleth/garrcert015e.bundle",
#		owner => "_shibd",
#		notify => Service['shibd']
#		}

	file { '/etc/shibboleth/attribute-map.xml' :
		ensure => file,
		source => "puppet:///modules/shib2/etc/shibboleth/attribute-map.xml",
		owner => "_shibd",
		notify => Service['shibd']
		}

	file { '/usr/lib/cgi-bin/env.rb' :
		ensure => file,
		source => "puppet:///modules/shib2/usr/lib/cgi-bin/env.rb",
		owner => "www-data",
		mode => "755"
		}

	file { '/etc/apache2/conf.d/security' :
		ensure => file,
		content => template("shib2/security.erb"),
		owner => "www-data",
		mode => "755"
		}

	file { '/etc/shibboleth/shibboleth2.xml' :
		ensure => file,
		content => template("shib2/shibboleth2.xml.erb"),
		owner => "_shibd",
		notify => Service['shibd']
		}

	exec { 'enable_shib2':
		command => "/usr/sbin/a2enmod shib2",
		creates => "/etc/apache2/mods-enabled/shib2.load",
		notify => Service['apache2']
	}

	service { 'shibd':
	      ensure     => running,
	      enable     => true,
	      hasrestart => true,
	      hasstatus  => false,
	      notify => Notify['env.rb']
	}	


#	notify { 'env.rb':
#		message => "Puoi testare le variabili di ambiente con shibboleth all'indirizzo: https://$fqdn/cgi-bin/env.rb"		
#	}
}
