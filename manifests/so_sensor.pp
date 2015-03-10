class profiles::so_sensor {

include profiles::default

class {"bro":}
class {"syslog_ng":
	syslog_ng_role => 'so',

	}

class { "elsa":

        elsa_type => 'SO_sensor'
#       elsa_type => 'standalone'


      }

  class   { "ssh::server":
  
        client_alive_count_max => '3',      
	client_alive_interval  => '30',
	
        }

}
