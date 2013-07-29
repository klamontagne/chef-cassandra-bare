

# set some nodes as seeds!
default[:cassandra][:seed] = false
default[:cassandra][:cluster_name] = "changeme"

default[:cassandra][:num_tokens] = 256
default[:cassandra][:listen_address] = node.ipaddress
default[:cassandra][:listen_address] = node.ipaddress
default[:cassandra][:endpoint_snitch] = "SimpleSnitch"
