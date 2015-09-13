#
# Cookbook Name:: postfix
# Recipe:: sasl
#
# Configures the saslauthd service.
#
# Copyright (c) 2015 Andy Lindeman.

package "sasl2-bin"

template "/etc/default/saslauthd" do
  owner "root"
  group "root"
  mode "0644"
  source "etc/default/saslauthd.erb"

  notifies :restart, "service[saslauthd]"
end

service "saslauthd" do
  action [:enable, :start]
end

group "sasl" do
  action :modify
  append true
  members ['postfix']
end
