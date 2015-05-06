#
# Cookbook Name:: mesos
# Recipe:: kubernetes_controller_manager
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

cookbook_file '/opt/restart-k8sm-controller-manager' do
  source 'restart-k8sm-controller-manager'
  mode '0755'
end

template '/etc/mesos/zk.tmpl' do
  source 'consul/zk.tmpl.erb'
end

template '/etc/mesos/kube-apiserver.tmpl' do
  source 'consul/kube-apiserver.tmpl.erb'
end

consul_template_config 'kubernetes-controller-manager' do
  templates [{
    source: '/etc/mesos/zk.tmpl',
    destination: '/etc/mesos/zk',
    command: '/opt/restart-k8sm-controller-managerr'
  },{
    source: '/etc/mesos/kube-apiserver.tmpl',
    destination: '/etc/mesos/kube-apiserver',
    command: '/opt/restart-k8sm-controller-manager'
  }]
  notifies :restart, 'service[consul-template]', :delayed
end

runit_service 'k8sm-controller-manager' do
  restart_on_update false
  default_logger true
  action [:enable, :down]
end
