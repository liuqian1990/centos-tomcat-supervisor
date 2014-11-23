centos-tomcat-supervisor
========================
docker pull aarongo/centos-tomcat-supervisor

Supervisor Management process
-----------------------------------  
### Superviso config
    [supervisord]
    nodaemon=true
    [program:sshd]
    command=/usr/sbin/sshd -D

    [program:tomcat]
    command = /usr/local/bin/tomcat7-run.sh
    stopasgroup = true
    redirect_stderr = true
    stdout_logfile = /var/log/supervisor/%(program_name)s.log

### Start docker supervisor tomcat and sshd
docker run -p 1024:22 -p 80:8080 -it -v /deploy:/deploy aarongo/centos-tomcat-supervisor
