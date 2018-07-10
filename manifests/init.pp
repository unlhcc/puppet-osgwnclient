#
# Class: osgwnclient
#

class osgwnclient {

  package { 'yum-plugin-priorities':
    ensure => installed,
  }

  package { 'osg-wn-client':
    ensure  => installed,
    require => Package['yum-plugin-priorities'],
  }

  package { 'osg-ca-certs':
    ensure => latest,
  }

  package { 'singularity':
    ensure => latest, # it has several suid root binaries
  }

  package { 'symlinks':
    ensure  => installed,
    require => Package['yum-plugin-priorities'],
  }

  ## Torque *requires* a home directory to be present.  Sigh.
  file { '/grid_home':
    ensure => symlink,
    path   => '/grid_home',
    target => '/var/lib/globus/job_home',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  service { 'condor':
    ensure => 'stopped',
    enable => false,
  }

  file { '/var/lib/condor-ce':
    ensure => directory,
    mode   => '0777',
  }
  mount { '/var/lib/condor-ce':
    ensure   => mounted,
    device   => 'ce1.sandhills.hcc.unl.edu:/var/lib/condor-ce',
    fstype   => 'nfs',
    options  => 'defaults,soft',
    remounts => true,
    target   => '/etc/fstab',
  }

  service { 'fetch-crl-cron':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
