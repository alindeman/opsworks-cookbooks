#
# Cookbook Name:: postfix
# Recipe:: configure
#
# Configures the Postfix service.
#
# Copyright (c) 2015 Andy Lindeman.

package "openssl"

if node["postfix"]["ssl_certificate"] && node["postfix"]["ssl_key"]
  ssl_certificate_file = "/etc/postfix/ssl.crt"
  file ssl_certificate_file do
    owner "root"
    group "root"
    mode "0644"

    content Base64.decode64(node["postfix"]["ssl_certificate"])

    notifies :restart, "service[postfix]"
  end

  ssl_key_file = "/etc/postfix/ssl.key"
  file ssl_key_file do
    owner "root"
    group "root"
    mode "0600"

    content Base64.decode64(node["postfix"]["ssl_key"])

    notifies :restart, "service[postfix]"
  end
else
  ssl_certificate_file = nil
  ssl_key_file = nil
end

dh_1024_param_file = "/etc/postfix/dh1024.pem"
execute "generate dh1024 param file" do
  # yes, we use 2048 bits: http://www.postfix.org/FORWARD_SECRECY_README.html#quick-start
  command "openssl dhparam -out #{dh_1024_param_file} 2048"
  not_if { ::File.exist?(dh_1024_param_file) }
  notifies :restart, "service[postfix]"
end

dh_512_param_file = "/etc/postfix/dh512.pem"
execute "generate dh512 param file" do
  command "openssl dhparam -out #{dh_512_param_file} 512"
  not_if { ::File.exist?(dh_512_param_file) }
  notifies :restart, "service[postfix]"
end

template "/etc/postfix/main.cf" do
  owner "root"
  group "root"
  mode "0644"
  source "etc/postfix/main.cf.erb"

  variables \
    hostname:                  node["postfix"]["hostname"],
    domain:                    node["postfix"]["domain"],
    destinations:              node["postfix"]["destinations"],
    ssl_certificate_file:      ssl_certificate_file,
    ssl_key_file:              ssl_key_file,
    dh_1024_param_file:        dh_1024_param_file,
    dh_512_param_file:         dh_512_param_file,
    relay:                     node["postfix"]["relay"]

  notifies :restart, "service[postfix]"
end

template "/etc/postfix/master.cf" do
  owner "root"
  group "root"
  mode "0644"
  source "etc/postfix/master.cf.erb"

  variables \
    incoming_message_size_limit:  node["postfix"]["incoming_message_size_limit"],
    outgoing_message_size_limit:  node["postfix"]["outgoing_message_size_limit"],
    submission:                   node["postfix"]["submission"]

  notifies :restart, "service[postfix]"
end

template "/etc/postfix/sasl/smtpd.conf" do
  owner "root"
  group "root"
  mode "0644"
  source "etc/postfix/sasl/smtpd.conf.erb"

  notifies :restart, "service[postfix]"
end

template "/etc/postfix/header_checks" do
  owner "root"
  group "root"
  mode "0644"
  source "etc/postfix/header_checks.erb"

  notifies :run, "execute[refresh smtp header hash table]", :immediately
end

execute "refresh smtp header hash table" do
  action :nothing
  command "postmap /etc/postfix/header_checks"
end

template "/etc/postfix/sasl_passwd" do
  owner "root"
  group "root"
  mode "0644"
  source "etc/postfix/sasl_passwd.erb"

  variables \
    relay:          node["postfix"]["relay"],
    relay_username: node["postfix"]["relay_username"],
    relay_password: node["postfix"]["relay_password"]

  notifies :run, "execute[refresh sasl_passwd hash table]", :immediately
end

execute "refresh sasl_passwd hash table" do
  action :nothing
  command "postmap /etc/postfix/sasl_passwd"
end

template "/etc/postfix/sender_relay" do
  owner "root"
  group "root"
  mode "0644"
  source "etc/postfix/sender_relay.erb"

  variables \
    destinations: node["postfix"]["destinations"],
    relay:        node["postfix"]["relay"]

  notifies :run, "execute[refresh sender_relay hash table]", :immediately
end

execute "refresh sender_relay hash table" do
  action :nothing
  command "postmap /etc/postfix/sender_relay"
end

template "/etc/aliases" do
  owner "root"
  group "root"
  mode "0644"
  source "etc/aliases.erb"

  variables \
    aliases: node["postfix"]["aliases"]

  notifies :run, "execute[newaliases]"
end

execute "newaliases" do
  action :nothing
  command "newaliases"
end
