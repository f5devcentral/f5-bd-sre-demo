## Install demo applications, and NGINX App Protect on the OpenShift

### Configuration Step
### Before proceeding this step, you should create the OCP user - 'dev_user' first. 

#### *Admin Console - Kubeadmin*
1. Deploy the critical app
You have to replace the image path within the yaml file with your NAP download path which you configured in a previous step. 

```
critical-app-with-nap.yaml

##################################################################################################
# Deploy Critical App with NGINX App Protect
##################################################################################################
apiVersion: v1
kind: Service
metadata:
  name: critical-app
  labels:
    app: critical-app
    service: critical-app
spec:
  ports:
  - port: 8888
    targetPort: 8888
    name: http
  selector:
    app: critical-app
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: critical-app-v1
  labels:
    app: critical-app
    version: v1
spec:
  replicas: 1
  selector:
    matchLabels:
      app: critical-app
      version: v1
  template:
    metadata:
      labels:
        app: critical-app
        version: v1
    spec:
      containers:
      - env:
        - name: TZ
          value: UTC
        name: nginx01
        image: yourcontainerimagepath (eg. your_docker_hub_id/app-protect:latest)
        volumeMounts:
        - name: config-volume
          mountPath: /etc/nginx/conf.d/nginx_sre.conf
          subPath: nginx_sre.conf
        - name: config-volume
          mountPath: /etc/nginx/NginxSRELabPolicy.json
          subPath: NginxSRELabPolicy.json
      - env:
        - name: TZ
          value: UTC
        name: critical-app
        image: network1211/ubuntu01:12.0
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 80
        command: [ "bash" ]
        args: [ "/start.sh" ]
      volumes:
      - name: config-volume
        configMap:
          name: critical-app-conf
---
```

2. Deploying NAP config file using 'config-map'
You have to add your real IP address of ELK server in the yaml file below.

```
##################################################################################################
# Configmap Critical-App
##################################################################################################
apiVersion: v1
kind: ConfigMap
metadata:
  name: critical-app-conf
data:
  nginx_sre.conf: | 
   
   upstream critical-app {
       server 127.0.0.1:80;            
   }
 
    server {
       listen 8888;
       server_name critical-app-http;
       proxy_http_version 1.1;
       
       real_ip_header X-Forwarded-For;     
       set_real_ip_from 0.0.0.0/0;
    
       app_protect_enable on;
       app_protect_security_log_enable on;
       app_protect_policy_file "/etc/nginx/NginxSRELabPolicy.json";
       app_protect_security_log "/etc/app_protect/conf/log_default.json" syslog:server=your_elk_server_ip_here;

       location / {
           client_max_body_size 0;
           default_type text/html;
           proxy_pass http://critical-app;
           proxy_set_header Host $host;
       }
   }
  NginxSRELabPolicy.json: |
    {
       "policy" : {
          "name" : "NGINX_App_Protect_Policy",
          "description" : "NGINX App Protect Strict Policy",
          "template": { "name": "POLICY_TEMPLATE_NGINX_BASE" },
          "applicationLanguage": "utf-8",
          "enforcementMode": "blocking",
          "response-pages": [
              {
                  "responseContent": "<html><head><title>SRE DevSecOps - East-West Attack Blocking</title></head><body><font color=green size=10>NGINX App Protect Blocking Page</font><br><br>Please consult with your administrator.<br><br>Your support ID is: <%TS.request.ID()%><br><br><a href='javascript:history.back();'>[Go Back]</a></body></html>",
                  "responseHeader": "HTTP/1.1 302 OK\\r\\nCache-Control: no-cache\\r\\nPragma: no-cache\\r\\nConnection: close",
                  "responseActionType": "custom",
                  "responsePageType": "default"
              }
          ],
          "blocking-settings" : {
              "evasions" : [
                  {
                     "description" : "Multiple decoding",
                     "maxDecodingPasses" : 2
                  }
              ],
              "http-protocols" : [
                 {
                    "description" : "Host header contains IP address",
                    "enabled" : false
                 }
              ],
              "violations" : [
                  {
                     "alarm" : true,
                     "block" : true,
                     "description" : "Violation Rating Need Examination detected",
                     "name" : "VIOL_RATING_NEED_EXAMINATION"
                  }
              ]
          },
          "signature-sets" : [
               {
                  "alarm" : true,
                  "block" : true,
                  "name" : "CVE Signatures"
               },
               {
                  "alarm" : true,
                  "block" : true,
                  "name" : "Buffer Overflow Signatures"
               },
               {
                  "alarm" : true,
                 "block" : true,
                  "name" : "Authentication/Authorization Attack Signatures"
               },
               {
                  "alarm" : true,
                  "block" : true,
                  "name" : "High Accuracy Signatures"
               },
               {
                  "alarm" : true,
                  "block" : true,
                  "name" : "SQL Injection Signatures"
               },
               {
                  "alarm" : true,
                  "block" : true,
                  "name" : "Cross Site Scripting Signatures"
               },
               {
                  "alarm" : true,
                  "block" : true,
                  "name" : "OS Command Injection Signatures"
               },
               {
                  "alarm" : true,
                  "block" : true,
                  "name" : "HTTP Response Splitting Signatures"
               },
               {
                  "alarm" : true,
                  "block" : true,
                  "name" : "Path Traversal Signatures"
               },
               {
                  "alarm" : true,
                  "block" : true,
                  "name" : "XPath Injection Signatures"
               },
               {
                  "alarm" : true,
                  "block" : true,
                  "name" : "Command Execution Signatures"
               },
               {
                  "alarm" : true,
                  "block" : true,
                  "name" : "Server Side Code Injection Signatures"
               },
               {
                  "alarm" : true,
                  "block" : true,
                  "name" : "Information Leakage Signatures"
               },
               {
                  "alarm" : true,
                  "block" : true,
                  "name" : "Directory Indexing Signatures"
               },
               {
                  "alarm" : true,
                  "block" : true,
                  "name" : "Remote File Include Signatures"
               },
               {
                  "alarm" : true,
                  "block" : true,
                  "name" : "Predictable Resource Location Signatures"
               },
               {
                  "alarm" : true,
                  "block" : true,
                  "name" : "Other Application Attacks Signatures"
               },
               {
                  "alarm" : true,
                  "block" : true,
                  "name" : "High Accuracy Detection Evasion Signatures"
               },
               {
                  "alarm" : true,
                  "block" : true,
                  "name" : "Generic Detection Signatures (High/Medium Accuracy)"
               }
          ]
       }
    }    
---
```

3. Deploy the 'critical-app' 
```
j.lee$ oc create -f critical-app-with-nap.yaml 
service/critical-app created
deployment.apps/critical-app-v1 created
j.lee$ oc create -f nap-config.yaml 
configmap/critical-app-conf created
j.lee$ oc get pods -o wide
NAME                               READY   STATUS    RESTARTS   AGE   IP            NODE                                             NOMINATED NODE   READINESS GATES
critical-app-v1-5c6546765f-wjhl9   2/2     Running   0          21s   10.129.2.71   ip-10-0-180-68.ap-southeast-1.compute.internal   <none>           <none>
j.lee$
```

#### *dev_user Console - infected machine*
1. Login to OCP cluster using 'dev_user' ID
Once you successfully login with ID 'dev_user', you have to create the project.
```
PS C:\Users\ljwca> oc login -u dev_user
Authentication required for https://yourocpdomain.com:6443 (openshift)
Username: dev_user
Password:
Login successful.

PS C:\Users\ljwca> oc new-project dev-test01
Now using project "dev-test01" on server "https://yourocpdomain.com:6443".

You can add applications to this project with the 'new-app' command. For example, try:

    oc new-app ruby~https://github.com/sclorg/ruby-ex.git

to build a new example application in Ruby. Or use kubectl to deploy a simple Kubernetes application:

    kubectl create deployment hello-node --image=gcr.io/hello-minikube-zero-install/hello-node

PS C:\Users\ljwca>
```

2. Deploy the 'test-app'
```
devapp_deployment.yaml

##################################################################################################
# Deploy Dev App
##################################################################################################
apiVersion: apps/v1
kind: Deployment
metadata:
  name: dev-test-v1
  labels:
    app: dev-test
    version: v1
spec:
  replicas: 1
  selector:
    matchLabels:
      app: dev-test
      version: v1
  template:
    metadata:
      labels:
        app: dev-test
        version: v1
    spec:
      containers:
      - env:
        - name: TZ
          value: UTC
        name: dev-test
        image: network1211/ubuntu02:5.0
        imagePullPolicy: IfNotPresent
        command: [ "bash" ]
        stdin: true
---
```

```
PS C:\Users\ljwca> oc create -f .\2-4_devapp-deployment.yaml
deployment.apps/dev-test-v1 created
PS C:\Users\ljwca>
PS C:\Users\ljwca> oc get pods -o wide
NAME                           READY   STATUS    RESTARTS   AGE   IP            NODE                                              NOMINATED NODE   READINESS GATES
dev-test-v1-674f467644-t94dc   1/1     Running   0          6s    10.128.2.38   ip-10-0-155-159.ap-southeast-1.compute.internal   <none>           <none>
PS C:\Users\ljwca>
```


