cookbook_file '/usr/local/bin/certbot-auto' do
  source 'certbot-auto'
  owner 'root'
  group 'root'
  mode 00755
  action :create
end

execute "/usr/local/bin/certbot-auto certonly --agree-tos --email=#{node['certbot']['email']} -n --standalone --domains=#{node['certbot']['domains'].join(',')}" do
  creates "/etc/letsencrypt/live"
  user 'root'
  action :run
end

template '/usr/local/bin/certbot-restart-dependent-services' do
  source 'certbot-restart-dependent-services.erb'
  owner 'root'
  mode 00755
  variables(
    services: node['certbot']['dependent_services']
  )
  action :create
end

cron 'renew certbot certificates' do
  minute '15'
  hour '*/12'
  user 'root'
  command "/usr/local/bin/certbot-auto renew --renew-hook=/usr/local/bin/certbot-restart-dependent-services"
  action :create
end
