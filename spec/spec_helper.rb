require 'open-uri'
require 'resolv'
require 'yaml'

def get_node_config(node, key)
  config = YAML.load_file("./.kitchen/#{node}-ec2.yml")
  key ? config.fetch(key) : config
end

def get_endpoint(id)
  endpoint = get_node_config('load-balancer', 'hostname')
  ip = Resolv.getaddress(endpoint)
  open("http://#{ip}", 'HOST' => "#{id}.#{endpoint}").read
rescue StandardError
  return false
end
