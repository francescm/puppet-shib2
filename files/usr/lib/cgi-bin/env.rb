#!/usr/bin/ruby

require 'cgi'
print "Content-type: text/html\n"

cgi = CGI.new('html4')

cgi.out do
  cgi.html do
    cgi.head do
      cgi.title{"Variabili di ambiente"}
    end +
    cgi.body do
      cgi.h1{"Variabili di ambiente"} +
      cgi.ul do
        "#{ENV.collect() do |key, value|
              "<li>" + key + " --> " + value + "</li>\n"
            end.join("")}"
      end 
    end
  end
end


#print CGI.new.params;
#print ENV.keys
#print ENV.inspect
