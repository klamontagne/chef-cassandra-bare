#
# Cookbook Name:: cassandra
# Recipe:: default
#
# Copyright 2013, De Marque Inc.
#
# All rights reserved - Do Not Redistribute
#

# http://www.datastax.com/documentation/gettingstarted

apt_repository "cassandra" do
  uri "http://debian.datastax.com/community"
  components ["stable","main"]
  key "http://debian.datastax.com/debian/repo_key"
end

package "dsc20"

# Set myself as seed if no other
if search(:node, "cassandra_seed:true AND chef_environment:#{node.chef_environment}").empty?
  node.set[:cassandra][:seed] = true
  node.save
end

# Get seeds IP
seeds = search(:node, "cassandra_seed:true AND chef_environment:#{node.chef_environment}")
seeds_ip = []
seeds.each do |s| 
  seeds_ip << s[:cassandra][:listen_address]
end

template "/etc/cassandra/cassandra.yaml" do
  source "cassandra-2.yaml.erb"
  owner "root"
  group "root"
  mode 0644
  variables(
    :cluster_name => node[:cassandra][:cluster_name],
    :num_tokens => node[:cassandra][:num_tokens],
    # set some nodes as seeds!
    :seeds_ip => seeds_ip.join(','),
    :listen_address => node[:cassandra][:listen_address],
    :rpc_address => node[:cassandra][:rpc_address],
    :endpoint_snitch => node[:cassandra][:endpoint_snitch]
  )
  notifies :restart, "service[cassandra]", :delayed 
end

#TOOD manage: "org.apache.cassandra.exceptions.ConfigurationException: Saved cluster name Test Cluster != configured name changeme"
# For the moment, just destroy the local data: rm -rf /var/lib/cassandra/*

service "cassandra" do
  action [ :enable, :start ]
end

# Backup with BURP
if node.recipe?("burp")
  cookbook_file "/etc/burp/pre.d/cassandra-backup-0-sh" do
    mode 0755
    owner "root"
    source "backup.sh"
  end
  cookbook_file "/etc/burp/post.d/cassandra-backup-0-sh" do
    mode 0755
    owner "root"
    source "post-backup.sh"
  end
end




