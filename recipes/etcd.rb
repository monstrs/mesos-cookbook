#
# Cookbook Name:: mesos
# Recipe:: etcd
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

include_recipe 'mesos::consul'
include_recipe 'etcd::binary_install'

template '/etc/init/etcd.conf' do
  mode 0644
end

service 'etcd' do
  provider Chef::Provider::Service::Upstart
  supports status: true, restart: true, reload: true
  action [:enable, :start]
end

consul_service_def 'etcd' do
  port 4001
  tags ['etcd']
  check(
    interval: node['mesos']['consul']['check_interval'],
    script: 'etcdctl cluster-health'
  )
  notifies :reload, 'service[consul]', :delayed
end
