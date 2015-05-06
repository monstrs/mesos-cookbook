#
# Cookbook Name:: mesos
# Recipe:: install
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

apt_repo 'mesosphere' do
  key_id 'E56151BF'
  keyserver 'keyserver.ubuntu.com'
  url "http://repos.mesosphere.io/#{node['platform']}"
  components ['main']
end

package 'mesos'

%w(mesos-master mesos-slave zookeeper).each do |srvc|
  service srvc do
    provider Chef::Provider::Service::Upstart
    action :disable
  end
end
