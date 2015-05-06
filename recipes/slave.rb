#
# Cookbook Name:: mesos
# Recipe:: slave
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

file '/etc/default/mesos-slave' do
  content <<-EOH
    MASTER=`cat /etc/mesos/zk`
    HOSTNAME=`cat /etc/hostname`
    IP=`hostname -i`
  EOH
end

template '/etc/mesos/zk.tmpl' do
  source 'consul/zk.tmpl.erb'
end

template '/etc/mesos/mesos-master.tmpl' do
  source 'consul/mesos-master.tmpl.erb'
end

consul_template_config 'mesos-slave' do
  templates [{
    source: '/etc/mesos/zk.tmpl',
    destination: '/etc/mesos/zk',
    command: 'service mesos-slave restart'
  },{
    source: '/etc/mesos/mesos-master.tmpl',
    destination: '/etc/mesos/mesos-master',
    command: 'service mesos-slave restart'
  }]
  notifies :restart, 'service[consul-template]', :delayed
end
