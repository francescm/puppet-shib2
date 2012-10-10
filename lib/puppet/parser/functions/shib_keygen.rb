module Puppet::Parser::Functions
  require 'fileutils'
  include FileUtils::Verbose
  newfunction(:shib_keygen) do |args|
    hostname = lookupvar('hostname')
    fqdn = lookupvar('fqdn')
#    hostname = args[0]
#    entity_id = args[1]
    entity_id = "https://#{fqdn}/shibboleth"
    function_notice(["applying shib-keygen: #{entity_id}"])
	if ! File.exists?("/etc/puppet/modules/shib2/files/etc/shibboleth/sp-key.pem-#{hostname}")
    cmd = IO.popen("/etc/puppet/modules/shib2/lib/puppet/parser/functions/shib-keygen -u puppet -g puppet -o /tmp -h #{fqdn} -e #{entity_id}")
#    cmd = IO.popen("./shib-keygen -o /tmp -h #{hostname} -e #{entity_id}")
    Puppet::Parser::Functions.autoloader.loadall
	err = cmd.read
	unless err.eql? ""
		raise Puppet::ParseError, "#{err}"
	end
     FileUtils::mv("/tmp/sp-cert.pem", "/etc/puppet/modules/shib2/files/etc/shibboleth/sp-cert.pem-#{hostname}")
     FileUtils::mv("/tmp/sp-key.pem", "/etc/puppet/modules/shib2/files/etc/shibboleth/sp-key.pem-#{hostname}")
#    puts cmd.read
    function_info(["exit from shib-keygen: #{cmd.read}"])
    end
  end
end
