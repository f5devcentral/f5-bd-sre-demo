## Prepare the 'NGINX App Protect' container image

### Configuration Step
#### *Please make sure that you already have the evaluation license from the F5 for your NAP.* 
#### *The evaluation license includes 1x'.crt' file and 1x'.key' file. These are required in this step.*
#### *You need to have your own 'Docker Hub' account.*

##### Create Dockerfile to build the 'NGINX App Protect' base image
You can find a more detailed explanation from the document portal of the NGINX [here](https://docs.nginx.com/nginx-app-protect/admin-guide/#docker-deployment).
Below is the sample 'Dockerfile' config which used in this demo. 

```
Dockerfile

# For CentOS 7:
FROM centos:7.4.1708

# Download certificate and key from the customer portal (https://cs.nginx.com)
# and copy to the build context:
COPY nginx-repo.crt nginx-repo.key /etc/ssl/nginx/

# Install prerequisite packages:
RUN yum -y install wget ca-certificates epel-release

# Add NGINX Plus repo to Yum:
RUN wget -P /etc/yum.repos.d https://cs.nginx.com/static/files/nginx-plus-7.repo
    
# Install NGINX App Protect:
RUN yum -y install app-protect \
    && yum clean all \
    && rm -rf /var/cache/yum \
    && rm -rf /etc/ssl/nginx
 
# Forward request logs to Docker log collector:
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log
        
# Copy configuration files:
COPY nginx.conf custom_log_format.json /etc/nginx/
COPY entrypoint.sh  ./
    
CMD ["sh", "/entrypoint.sh"] 
```

And build your docker image for NAP. (You have to place your NGINX 'crt' and 'key' files on the same directory.)
```
sudo docker build --no-cache -t app-protect .
```

Once you successfully complete your NAP installation, you should be able to find your NAP image like below. 
```
[james@James-Int-Centos nginx_sre]$ sudo docker images
REPOSITORY                TAG                 IMAGE ID            CREATED             SIZE
app-protect               latest              69eab65e11f0        32 seconds ago      580MB
```

You have to access the shell of the NAP image and move to /etc/nginx directory. 
```
[james@James-Int-Centos nginx_sre]$ sudo docker run -ti 69eab65e11f0 /bin/bash
[root@a7de84db35b0 /]# 
[root@a7de84db35b0 /]# cd /etc/nginx/
[root@a7de84db35b0 nginx]# ls
NginxApiSecurityPolicy.json  NginxDefaultPolicy.json  NginxStrictPolicy.json  conf.d  custom_log_format.json  fastcgi_params  koi-utf  koi-win  mime.types  modules  nginx.conf  scgi_params  uwsgi_params  win-utf
[root@a7de84db35b0 nginx]#
```

Open the 'nginx.conf' file using vi editor and update the context like below. 
```
[root@9b298513fad7 nginx]# cat nginx.conf 
user nginx;

worker_processes auto;
load_module modules/ngx_http_app_protect_module.so;

error_log /var/log/nginx/error.log debug;

events {
    worker_connections 10240;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;
    sendfile on;
    keepalive_timeout 65;
    include /etc/nginx/conf.d/nginx_sre.conf;
}
```

And logout from the NAP image using 'exit' command. 

Now, you need to login to your docker account using the command line below. 
```
root@James-Ext-ubuntu:/home/james# docker login --username=yourusername 
Password: yourpassword
WARNING! Your password will be stored unencrypted in /root/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
```

After login, you have to save the configuration changes to your NAP image and upload it to your docker hub repo. 
```
[root@James-Int-Centos nginx_sre]# docker ps -a
CONTAINER ID        IMAGE                         COMMAND                CREATED             STATUS                     PORTS               NAMES
a7de84db35b0        69eab65e11f0                  "/bin/bash"            9 minutes ago       Up 9 minutes                                   confident_bell

[root@James-Int-Centos nginx_sre]# docker commit a7de84db35b0
sha256:307d826879dd9766dcbc17bdfe9260eda4f26d84688cf446759d832b16614d22
[root@James-Int-Centos nginx_sre]# 

[root@James-Int-Centos nginx_sre]# docker images
REPOSITORY                TAG                 IMAGE ID            CREATED             SIZE
<none>                    <none>              307d826879dd        7 seconds ago       580MB
app-protect               latest              69eab65e11f0        16 minutes ago      580MB

[root@James-Int-Centos nginx_sre]# docker tag 307d826879dd your_docker_hub_id/app-protect:latest
[root@James-Int-Centos nginx_sre]# 
[root@James-Int-Centos nginx_sre]# docker images
REPOSITORY                TAG                 IMAGE ID            CREATED              SIZE
your_id/app-protect       latest              307d826879dd        About a minute ago   580MB
app-protect               latest              69eab65e11f0        17 minutes ago       580MB

[root@James-Int-Centos nginx_sre]# docker push your_id/app-protect 
The push refers to repository [docker.io/your_id/app-protect]
.
.
latest: digest: sha256:abbe81a2845b1ae0d36b14efbcc2dd11b9f401139ce57ec528d3b74244385871 size: 1989
[root@James-Int-Centos nginx_sre]#
```



