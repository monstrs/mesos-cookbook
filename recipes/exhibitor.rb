#
# Cookbook Name:: mesos
# Recipe:: exhibitor
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

include_recipe 'runit'
include_recipe 'mesos::consul'
include_recipe 'zookeeper::install'
include_recipe 'exhibitor::default'

runit_service 'exhibitor' do
  restart_on_update false
  default_logger true
  action [:enable]
end

consul_service_def 'exhibitor' do
  port node['exhibitor']['cli']['port']
  tags ['exhibitor']
  check(
    interval: node['mesos']['consul']['check_interval'],
    http: "http://localhost:#{node['exhibitor']['cli']['port']}/exhibitor/v1/cluster/status"
  )
  notifies :reload, 'service[consul]'
end

consul_service_def 'zookeeper' do
  port node['zookeeper']['config']['clientPort']
  tags ['zookeeper']
  check(
    interval: node['mesos']['consul']['check_interval'],
    script: "echo ruok | nc localhost #{node['zookeeper']['config']['clientPort']}"
  )
  notifies :reload, 'service[consul]', :delayed
end
