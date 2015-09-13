#
# Cookbook Name:: users
# Recipe:: default
#
# Copyright (c) 2015 Andy Lindeman.

chef_gem 'ruby-shadow'

node['users']['users'].each do |username, attributes|
  user username do
    shell attributes.fetch('shell', '/bin/false')
    password attributes.fetch('password', '*')
  end
end
