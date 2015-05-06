#
# Cookbook Name:: mesos
# Attributes:: default
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

default['java']['jdk_version'] = '7'

default['exhibitor']['user']                   = 'root'
default['exhibitor']['cli']['port']            = 7070
default['exhibitor']['config']['servers_spec'] = ''

default['zookeeper']['config']['dataLogDir'] = '/tmp/zookeeper'
default['zookeeper']['config']['dataDir']    = '/tmp/zookeeper'

default['consul']['data_dir']                   = '/tmp/consul'
default['consul']['init_style']                 = 'runit'
default['consul']['service_mode']               = 'cluster'
default['consul']['extra_params']['atlas_join'] = true

default['consul_template']['log_level']     = 'debug'
default['consul_template']['init_style']    = 'runit'
default['consul_template']['service_user']  = 'root'
default['consul_template']['service_group'] = 'root'

default['etcd']['version'] = '2.0.10'
default['etcd']['sha256']  = 'c597cb3684b9304ae86f0e3145204c75cf4720080bfecb796a8980044f7a45c3'

default['mesos']['consul']['check_interval'] = '60s'

default['mesos']['cluster']   = 'Default'
default['mesos']['quorum']    = '1'
default['mesos']['registry']  = 'in_memory'
default['mesos']['work_dir']  = '/var/lib/mesos'

default['mesos']['master']['port'] = 5050

default['mesos']['slave']['resources'] = 'ports(*):[31000-32000]'

default['mesos']['kubernetes']['port']         = 8888
default['mesos']['kubernetes']['target']       = '/var/lib/kubernetes'
default['mesos']['kubernetes']['mesos_user']   = 'root'
default['mesos']['kubernetes']['portal_net']   = '10.10.10.0/24'
default['mesos']['kubernetes']['revision']     = '95a1a3ea338315990b42a97593edfd3c8d466c8b'
default['mesos']['kubernetes']['log_level']    = 2
