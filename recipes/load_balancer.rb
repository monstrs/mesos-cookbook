#
# Cookbook Name:: mesos
# Recipe:: load_balancer
#
# Copyright 2015, Andrey Linko
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'confd'
include_recipe 'haproxy'
include_recipe 'etcd::binary_install'
include_recipe 'mesos::consul'

template '/etc/confd/confd.toml.tmpl' do
  source 'consul/confd.toml.tmpl.erb'
end

consul_template_config 'confd' do
  templates [{
    source: '/etc/confd/confd.toml.tmpl',
    destination: '/etc/confd/confd.toml',
    command: 'sv restart confd'
  }]
  notifies :restart, 'service[consul-template]', :delayed
end

template '/etc/confd/conf.d/load-balancer.toml' do
  source 'confd/load-balancer.toml.erb'
  mode 00644
end

template '/etc/confd/templates/haproxy.tmpl' do
  source 'confd/haproxy.tmpl.erb'
  mode 00644
end
