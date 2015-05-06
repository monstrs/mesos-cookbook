#
# Cookbook Name:: mesos
# Recipe:: kubernetes_install
#
# Copyright 2014, Andrey Linko
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

include_recipe 'docker'
include_recipe 'mesos::install'

directory "#{node['mesos']['kubernetes']['target']}/bin" do
  recursive true
end

git "#{node['mesos']['kubernetes']['target']}/k8sm" do
  repository 'https://github.com/mesosphere/kubernetes-mesos.git'
  action :sync
end

docker_container 'kubernetes-mesos' do
  container_name 'kubernetes-mesos'
  image 'mesosphere/kubernetes-mesos:build'
  volume ["#{node['mesos']['kubernetes']['target']}/bin:/target"]
  env "GIT_BRANCH=#{node['mesos']['kubernetes']['revision']}"
  remove_automatically true
  cmd_timeout 3600
  init_type false
  attach true
  action :run
  not_if { ::File.exist? "#{node['mesos']['kubernetes']['target']}/bin/kube-apiserver" }
end
