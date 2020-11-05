### Simulate the demo

*You should start the Kibana watcher and logstash first before proceeding this step.*

#### Kubeadmin Console
1. Please make sure you're logged in to the OCP cluster using 'kubeadmin' account. And confirm the 'critical-app' is running correctly.
```
j.lee$ oc whoami
kube:admin
j.lee$ 
j.lee$ oc get projects
NAME                                               DISPLAY NAME   STATUS
critical-app                                                      Active
default                                                           Active
dev-test02                                                        Active
kube-node-lease                                                   Active
kube-public                                                       Active
kube-system                                                       Active
openshift                                                         Active
openshift-apiserver                                               Active
openshift-apiserver-operator                                      Active
openshift-authentication                                          Active
openshift-authentication-operator                                 Active
openshift-cloud-credential-operator                               Active

j.lee$ oc get pods -o wide
NAME                               READY   STATUS    RESTARTS   AGE   IP            NODE                                             NOMINATED NODE   READINESS GATES
critical-app-v1-5c6546765f-wjhl9   2/2     Running   1          85m   10.129.2.71   ip-10-0-180-68.ap-southeast-1.compute.internal   <none>           <none>
j.lee$ 
```

#### dev_user Console
1. Please make sure you're logged in to the OCP cluster using 'dev_user' account on the 'infected machine'. And confirm the 'dev-test-app' is running correctly.
```
PS C:\Users\ljwca\Documents\ocp> oc whoami
dev_user
PS C:\Users\ljwca\Documents\ocp>
PS C:\Users\ljwca\Documents\ocp> oc get projects
NAME         DISPLAY NAME   STATUS
dev-test02                  Active
PS C:\Users\ljwca\Documents\ocp>
PS C:\Users\ljwca\Documents\ocp> oc get pods -o wide
NAME                           READY   STATUS    RESTARTS   AGE   IP            NODE                                              NOMINATED NODE   READINESS GATES
dev-test-v1-674f467644-t94dc   1/1     Running   0          6s    10.128.2.38   ip-10-0-155-159.ap-southeast-1.compute.internal   <none>           <none>
```

2. Login to 'dev-test' container using 'remote shell' command of the OCP
```
PS C:\Users\ljwca\Documents\ocp> oc rsh dev-test-v1-674f467644-t94dc
$
$ uname -a
Linux dev-test-v1-674f467644-t94dc 4.18.0-193.14.3.el8_2.x86_64 #1 SMP Mon Jul 20 15:02:29 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux
$
```

3. Network scanning
- This step takes 1~2 hours to complete all scanning. 
```
$ nmap -sP 10.128.0.0/14
Starting Nmap 7.80 ( https://nmap.org ) at 2020-09-29 17:20 UTC
Nmap scan report for ip-10-128-0-1.ap-southeast-1.compute.internal (10.128.0.1)
Host is up (0.0025s latency).
Nmap scan report for ip-10-128-0-2.ap-southeast-1.compute.internal (10.128.0.2)
Host is up (0.0024s latency).
Nmap scan report for 10-128-0-3.metrics.openshift-authentication-operator.svc.cluster.local (10.128.0.3)
Host is up (0.0023s latency).
Nmap scan report for 10-128-0-4.metrics.openshift-kube-scheduler-operator.svc.cluster.local (10.128.0.4)
Host is up (0.0027s latency).
.
.
.
```
After completion of the scanning, you will be able to find the 'critical-app' on the list. 

4. Application Scanning for the target
- You can find the 'open' service ports on the target using nmap. 
```
$ nmap 10.129.2.71
Starting Nmap 7.80 ( https://nmap.org ) at 2020-09-29 17:23 UTC
Nmap scan report for 10-129-2-71.critical-app.critical-app.svc.cluster.local (10.129.2.71)
Host is up (0.0012s latency).
Not shown: 998 closed ports
PORT     STATE SERVICE
80/tcp   open  http
8888/tcp open  sun-answerbook

Nmap done: 1 IP address (1 host up) scanned in 0.12 seconds
$
```

But you will see the 403 error when you try to access the server using port 80. This happens because the default Apache access control only allows the traffic from the NGINX App Protect. 
```
$ curl http://10.129.2.71/
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html><head>
<title>403 Forbidden</title>
</head><body>
<h1>Forbidden</h1>
<p>You don't have permission to access this resource.</p>
<hr>
<address>Apache/2.4.46 (Debian) Server at 10.129.2.71 Port 80</address>
</body></html>
$
```

Now, you can see the response through the port 8888. 
```
$ curl http://10.129.2.71:8888/
<html>
<head>
<title>
Network Operation Utility - NSLOOKUP
</title>
</head>
<body>

    <font color=blue size=12>NSLOOKUP TOOL</font><br><br>
    <h2>Please type the domain name into the below box.</h2>
    <h1>

    <form action="/index.php" method="POST">

        <p>

        <label for="target">DNS lookup:</label>
        <input type="text" id="target" name="target" value="www.f5.com">

        <button type="submit" name="form" value="submit">Lookup</button>

        </p>

    </form>
    </h1>
    <font color=red>This site is vulnerable to Web Exploit. Please use this site as a test purpose only.</font>

</body>

</html>
$
```

5. Performing the 'Command Injection' attack
```
$ curl -d "target=www.f5.com|cat /etc/passwd&form=submit" -X POST http://10.129.2.71:8888/index.php
<html><head><title>SRE DevSecOps - East-West Attack Blocking</title></head><body><font color=green size=10>NGINX App Protect Blocking Page</font><br><br>Please consult with your administrator.<br><br>Your support ID is: 878077205548544462<br><br><a href='javascript:history.back();'>[Go Back]</a></body></html>$
$
```

6. Verify the logs in Kibana dashboard
- You shoudl be able to see the NAP alerts on your ELK.
![](https://github.com/network1211/f5-security-automation-ansible/blob/master/devsecops/malicious_pod/images/elk_dashboard.png)

7. Verify the Ansible terminates the malicious pod
- Ansible deletes the malicious POD
![](https://github.com/network1211/f5-security-automation-ansible/blob/master/devsecops/malicious_pod/images/terminating_pod.png)









