node default {
  group { 'puppet': ensure => present }
  Exec { path => ['/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/'], }
  File { owner => 0, group => 0, mode => 0644, }

  include opsscripts

  class { 'apt': }

  Class['::apt::update'] -> Package <| 
    title != 'python-software-properties' and 
    title != 'software-properties-common' 
    |>

  class { 'java8': }

  class { 'elasticsearch':
    manage_repo      => true,
    repo_version     => '1.4',
    config           => {
      'cluster.name' => 'cluster',
    },
  }

  elasticsearch::instance { 'es01':
    config  => {
      'node.name' => 'es01',
    },
    datadir => '/var/lib/es-data-es01',
  }

  elasticsearch::instance { 'es02':
    config  => {
      'node.name' => 'es02',
    },
    datadir => '/var/lib/es-data-es02',
  }
}
