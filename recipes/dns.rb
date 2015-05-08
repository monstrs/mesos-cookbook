#
# Cookbook Name:: mesos
# Recipe:: dns
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
include_recipe 'golang'
include_recipe 'build-essential'
include_recipe 'mesos::consul'

golang_package 'github.com/tools/godep' do
  not_if { ::File.exist? '/usr/local/bin/mesos-dns' }
end

execute 'make mesos-go' do
  command <<-CMD
    export PATH=$PATH:#{node['go']['install_dir']}/go/bin:#{node['go']['gopath']}/bin
    go get github.com/mesosphere/mesos-dns
    cd $GOPATH/src/github.com/mesosphere/mesos-dns
    make all
  CMD
  cwd Chef::Config[:file_cache_path]
  environment(
    'GOPATH' => node['go']['gopath'],
    'GOBIN' => '/usr/local/bin'
  )
  not_if { ::File.exist? '/usr/local/bin/mesos-dns' }
end

directory '/etc/mesos-dns' do
  recursive true
end

template '/etc/mesos-dns/config.json.tmpl' do
  source 'consul/mesos-dns.tmpl.erb'
end

consul_template_config 'mesos-dns' do
  templates [{
    source: '/etc/mesos-dns/config.json.tmpl',
    destination: '/etc/mesos-dns/config.json',
    command: 'sv restart mesos-dns'
  }]
  notifies :restart, 'service[consul-template]', :delayed
end

runit_service 'mesos-dns' do
  restart_on_update false
  default_logger true
  action [:enable, :down]
end
