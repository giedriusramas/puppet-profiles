class profiles::syslog_ng_server {

include  profiles::linux_default 

class {"syslog_ng":
        syslog_ng_role => 'syslog_ng_server',

        }

}

