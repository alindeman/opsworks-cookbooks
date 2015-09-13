#
# Cookbook Name:: postfix
# Recipe:: srs
#
# Installs a Sender Rewriting Scheme daemon.
#
# Copyright (c) 2015 Andy Lindeman.

postsrsd_revision = "90718d708b2090900d3302f8374441fc78f63f5f"

package "cmake"

remote_file "/tmp/postsrsd_#{postsrsd_revision}.tar.gz" do
  action :create_if_missing
  source "https://github.com/alindeman/postsrsd/archive/#{postsrsd_revision}.tar.gz"
end

directory "/tmp/postsrsd_#{postsrsd_revision}"

execute "untar postsrsd" do
  command "tar -C /tmp/postsrsd_#{postsrsd_revision} --strip-components=1 -xvzf /tmp/postsrsd_#{postsrsd_revision}.tar.gz"
  not_if { ::File.exist?("/tmp/postsrsd_#{postsrsd_revision}/README.md") }
end

execute "install postsrsd" do
  command "make && make install"
  cwd "/tmp/postsrsd_#{postsrsd_revision}"

  not_if { ::File.exist?("/usr/local/sbin/postsrsd") }
end

service "postsrsd" do
  action [:enable, :start]
  provider Chef::Provider::Service::Upstart
end
