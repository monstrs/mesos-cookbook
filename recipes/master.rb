#
# Cookbook Name:: mesos
# Recipe:: master
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

include_recipe 'java'
include_recipe 'mesos::consul'
include_recipe 'mesos::install'

file '/etc/mesos-master/cluster' do
  content node['mesos']['cluster']
end

file '/etc/mesos-master/quorum' do
  content node['mesos']['quorum']
end

file '/etc/mesos-master/registry' do
  content node['mesos']['registry']
end

file '/etc/mesos-master/work_dir' do
  content node['mesos']['work_dir']
end

file '/etc/default/mesos-master' do
  content <<-EOH
    PORT=#{node['mesos']['master']['port']}
    ZK=`cat /etc/mesos/zk`
    HOSTNAME=`cat /etc/hostname`
    IP=`hostname -i`
  EOH
end

template '/etc/mesos/zk.tmpl' do
  source 'consul/zk.tmpl.erb'
end

consul_template_config 'mesos-master' do
  templates [{
    source: '/etc/mesos/zk.tmpl',
    destination: '/etc/mesos/zk',
    command: 'service mesos-master restart'
  }]
  notifies :restart, 'service[consul-template]', :delayed
end

consul_service_def 'mesos-master' do
  port node['mesos']['master']['port']
  tags ['mesos-master']
  check(
    interval: node['mesos']['consul']['check_interval'],
    script: "curl http://`hostname -i`:#{node['mesos']['master']['port']}/master/state.json"
  )
  notifies :reload, 'service[consul]', :delayed
end
