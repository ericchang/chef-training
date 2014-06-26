#
# Cookbook Name:: apache
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


# 1. Install apache
#
# OLD: `apt-get install httpd`
package "httpd" do
  action :install # see actions section below
end

service "httpd" do
	action [:enable, :start]
end

cookbook_file "/var/www/html/index.html" do
	source node["apache"]["indexfile"]
	mode "0644"
end

# 2. Put the homepage in place
# 3. Start and enable the service
