#
# Cookbook Name:: postfix
# Recipe:: service
#
# Enables and starts the Postfix service.
#
# Copyright (c) 2015 Andy Lindeman.

service "postfix" do
  action [:enable, :start]
  supports restart: true, reload: true
end
