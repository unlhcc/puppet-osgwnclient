#
# Class: osgwnclient
#

class osgwnclient {

	package { yum-priorities:	name => "yum-plugin-priorities",	ensure => installed, }

	package { osg-wn-client:
	        name => "osg-wn-client",
		ensure => installed,
		require => Package["yum-priorities"],
	}

	#package { glexec:
	#	name => "glexec.x86_64",
	#	ensure => installed,
	#	require => Package["yum-priorities"],
	#}

	#package { lcmaps:
	#	name => "lcmaps.x86_64",
	#	ensure => latest,
	#	require => Package["yum-priorities"],
	#}

	#package { "lcmaps-plugins-process-tracking.x86_64":
	#	ensure => latest,
	#	require => Package["yum-priorities"],
	#}

	#package { "lcmaps-plugins-mount-under-scratch.x86_64":
	#	ensure => latest,
	#	require => Package["yum-priorities"],
	#}
  #      package { "lcmaps-plugins-scas-client.x86_64":
	#	ensure => latest,
	#	require => Package["yum-priorities"],
	#}

	package { "symlinks":
		ensure => installed,
		require => Package["yum-priorities"],
	}

	#file { "glexec.conf":
	#	path    => "/etc/glexec.conf",
	#	owner   => "root", group => "glexec", mode => 640,
	#	ensure  => present,
	#	require => Package["glexec"],
	#	content => template("osg-wn-client/glexec.conf.erb"),
	#}

	#file { "lcmaps.db":
	#	path    => "/etc/lcmaps.db",
	#	owner   => "root", group => "root", mode => 644,
	#	require => [Package["lcmaps"],
	#		    Package["lcmaps-plugins-mount-under-scratch.x86_64"],
	#		    Package["lcmaps-plugins-process-tracking.x86_64"]],
	#	content => template("osg-wn-client/lcmaps.db.erb"),
	#}

	## Torque *requires* a home directory to be present.  Sigh.
	file { "/grid_home":
		path	=> "/grid_home",
		owner	=> "root", group => "root", mode => '0644',
		ensure	=> symlink,
		target	=> "/var/lib/globus/job_home",
	}

	service { "condor":
		name	=> "condor",
		enable	=> false,
		ensure	=> "stopped",
        }

	mount { "/var/lib/condor-ce":
		name	=> "/var/lib/condor-ce",
		ensure	=> mounted,
		device	=> "ce1.sandhills.hcc.unl.edu:/var/lib/condor-ce",
		fstype	=> "nfs",
		options	=> "defaults,soft",
		remounts	=> true,
		target	=> "/etc/fstab",
	}

	service {"fetch-crl-boot":
    ensure  => running,
    enable  => true,
    hasstatus  => true,
    hasrestart => true,
  }

	service {"fetch-crl-cron":
    ensure  => running,
    enable  => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
