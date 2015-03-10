
class profiles::default {
package { 'atop': ensure => installed,}
package { 'git': ensure => installed,}
class { "nano":}

   class { 'bash':
      config_file_template => "bash/${::lsbdistcodename}/etc/skel/bashrc.erb",
      config_file_hash     => {
        '.bash_aliases_skel' => {
          config_file_path   => '/etc/skel/.bash_aliases',
          config_file_source => 'puppet:///modules/bash/common/etc/skel/bash_aliases',
        },
        '.bash_aliases_root' => {
          config_file_path   => '/root/.bash_aliases',
          config_file_source => 'puppet:///modules/bash/common/etc/skel/bash_aliases',
        },
        '.bashrc'            => {
          config_file_path     => '/root/.bashrc',
          config_file_template => "bash/${::lsbdistcodename}/etc/skel/bashrc.erb",
        },
      },
    }



account { 
  'karolis':
    home_dir => '/home/karolis',
    groups   => [ 'sudo', 'users' ],
    comment   => 'SysAdmin user',
}


account { 
  'giedrius':
    home_dir => '/home/giedrius',
    groups   => [ 'sudo', 'users' ],
   ssh_key => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDScR+ht5zBPANnfjGl1XhZdvngwmUhrZ2lksEZzKafgD0TMwp1lBV9NZjOTOwPGhWVLoEqX5Pmc8J4wbOBJF1YhA8M1becZaQt78Bk+622w7rPMwFaHDmh04PSJPTk98YOIORdap5EYYd/Pb5EZtsyFi1VrQXO2zlj7V+fNY/fnujTb7awWAhmE82bkXutY36xT5myv4hnQgHgZ6z9ty2BvgvNXoCkCQmAzKHkgA/J8v5puMVAGnRcskVbZHQ0l+nXlP/Lob8+x35zMp3RTUI/erYlG730Ppnp4V6sUj2ICJGSMIpM1cfKXpxmg7vy1U/xgxatG5tdG+oq1eHenRS3',
    comment   => 'SysAdmin user',

}

account { 
  'audrius':
    home_dir => '/home/audrius',
    ssh_key => 'AAAAB3NzaC1yc2EAAAABJQAAAQEAwymKbcvgEXvV3I+mkLfOEaev4vcu9xnqubicYMevYXbG5xz2BihuMX+LWeRmlalu5WR/IRrma42c/v6nU0mNlpiqLVyA4yQnRwkMSTOnMRXr8limK1jS/9aUEc98X2x2dgM6wxkYJXKbsXBEbFuo8aRJ5VrIRk8623F3dP1KkieRfn3Fzxyo0u5cvl2XUKPhu0eNxY22YfRwvaggY4UIQvX8+Cr1sBeBlMYUNtRLxduGscO9ge2a6v/3S8D16N5OVBMmqTpxM1LiB04rzPMm8afjCkm83Gqh/et+NFZqp+D4mBCb9fyqI0VoUeNOdqq1jeSRFnbnZrRSoghfHVBN3w==',
    groups   => [ 'sudo', 'users' ],
    comment   => 'SysAdmin user',
}

sudo::sudoers { 'kss':
  ensure   => 'present',
  comment  => 'kss vartotojai',
  users    => ['giedrius', 'karolis','audrius'],
  runas    => ['root'],
  cmnds    => ['ALL'],
  tags     => ['NOPASSWD'],
  defaults => [ 'env_keep += "SSH_AUTH_SOCK"' ]
}


  




}
