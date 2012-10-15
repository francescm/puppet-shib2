# Puppet module to install shibboleth2-sp on Debian.

Tested on Debian squeeze and Debian wheezy with puppet 3.0.0-1puppetlabs1

## Prerequisites: 
apache2 with mod_ssl

## How it works:
The module create key and certificates on puppetmaster, the move them to host. Host EntityId is: https://$fqdn/shibboleth.

If you want to modify shibboleth2.xml for a given host, please create a shibboleth2.xml.$hostname.erb in ~/templates.

Please modify shibboleth2.xml with sessionInitiator and metadata section suitable for your site.

