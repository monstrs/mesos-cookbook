#
# Cookbook Name:: mesos
# Recipe:: kubernetes_apipserver
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
include_recipe 'mesos::kubernetes_install'

cookbook_file '/opt/restart-kube-apiserver' do
  source 'restart-kube-apiserver'
  mode '0755'
end

template '/etc/mesos/zk.tmpl' do
  source 'consul/zk.tmpl.erb'
end

template '/etc/mesos/mesos-master.tmpl' do
  source 'consul/mesos-master.tmpl.erb'
end

template '/etc/mesos/etcd.tmpl' do
  source 'consul/etcd.tmpl.erb'
end

consul_template_config 'kubernetes-apiserver' do
  templates [{
    source: '/etc/mesos/zk.tmpl',
    destination: '/etc/mesos/zk',
    command: '/opt/restart-kube-apiserver'
  },{
    source: '/etc/mesos/mesos-master.tmpl',
    destination: '/etc/mesos/mesos-master',
    command: '/opt/restart-kube-apiserver'
  },{
    source: '/etc/mesos/etcd.tmpl',
    destination: '/etc/mesos/etcd',
    command: '/opt/restart-kube-apiserver'
  }]
  notifies :restart, 'service[consul-template]', :delayed
end

consul_service_def 'kube-apiserver' do
  port node['mesos']['kubernetes']['port']
  tags ['kube-apiserver']
  check(
    interval: node['mesos']['consul']['check_interval'],
    script: "curl http://`hostname -i`:#{node['mesos']['kubernetes']['port']}/healthz/ping"
  )
  notifies :reload, 'service[consul]', :delayed
end

runit_service 'kube-apiserver' do
  restart_on_update false
  default_logger true
  action [:enable, :down]
end
