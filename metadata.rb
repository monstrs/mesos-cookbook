name              'mesos'
maintainer        'Andrey Linko'
maintainer_email  'AndreyLinko@gmail.com'
license           'Apache 2 License'
description       'Installs/Configures mesos'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '0.1.0'

supports 'ubuntu'

depends 'git'
depends 'etcd'
depends 'java'
depends 'runit'
depends 'docker'
depends 'apt-repo'
depends 'exhibitor'
depends 'zookeeper'
depends 'consul'
depends 'confd'
depends 'haproxy'
depends 'consul-template'
