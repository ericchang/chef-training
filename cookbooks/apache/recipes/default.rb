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

# disable the default virtual host
execute "mv /etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/welcome.conf.disabled" do
	only_if do
		File.exist?("/etc/httpd/conf.d/welcome.conf")
	end
	notifies :restart, "service[httpd]"
end

# iterate over the apache sites
node["apache"]["sites"].each do |site_name, site_data|
	# set the document root
	document_root = "/srv/apache/#{site_name}"

	# add a template for Apache virtual host configuration
	template "/etc/httpd/conf.d/#{site_name}.conf" do
		source "custom.erb"
		mode "0644"
		variables(
			:document_root => document_root,
			:port => site_data["port"]
			)
		notifies :restart, "service[httpd]"
	end

	# adds a directory resource to create the document_root
	directory "#{document_root}" do
		mode "0755"
		recursive true
	end

	template "#{document_root}/index.html" do
		source "index.html.erb"
		mode "0644"
		variables(:site_name => site_name, :port => site_data["port"])
	end
end

service "httpd" do
	action [:enable, :start]
end


# 2. Put the homepage in place
# 3. Start and enable the service
