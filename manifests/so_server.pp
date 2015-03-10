class profiles::so_server {

include profiles::default


class { "elsa":

        elsa_type => 'SO_server'
#       elsa_type => 'standalone'


      }

}
