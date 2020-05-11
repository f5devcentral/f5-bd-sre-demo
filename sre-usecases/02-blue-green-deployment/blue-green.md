# Building Blue-Green Deployment

Blue-green deployment uses two versions of the application running simultaneously in two identical production environments called Blue (OpenShift Cluster dRouter **aws1-az1** in this demo) and Green (OpenShift Cluster dRouter **aws2-az1**). 

First, you use the Route object to point to the current version. Then you start the new version and switch the Route to the new pods. After you test the new version and are satisfied with it, you can scale down the previous one and delete that Deployment.

For this demo, we’ll start with a simple app: “app1”. This app is an example Nginx HTTP server and a reverse proxy (nginx) application that serves static content, and displays the Openshift cluster version. 

Note that for each cluster, we assume you already have the application "app1" deployed, service created, and OpenShift route created. If you are looking for application migration, Red Hat provides a set of tooll: Custer Application Migration (CAM), and Control Plan Migration Assistance (CPMA).

## Step 1: Map Route to Blue
To start with, we will configure F5 Cloud Service to send all traffic for app1.thebizdevops.net traffic to Blue, as shown in the graphic below:
![blue](./images/blue1)

**Retrieve route from Blue**

Retrieve the routes of project “default" from the Blue deployment
```
./project-retrieve default aws1-az1
 ```
This command retrieves all the routes of the given project/namespace ("default") and the specified dRouter, ands store this information in the desired GSLB store.

**Publish route to F5 Cloud Service**
Next, we can submit this configuration into F5 Cloud Service with the *gslb-commit* command. 

```
./gslb-commit
PLAY [localhost] **************************************************************************************************************************************************************
Friday 01 May 2020  16:05:50 -0700 (0:00:00.822)       0:00:00.822 ************
...
...
f5aas-gslb-prepare-subscription : retrieve result ---------------------------------------------------------------------------------------------------------------------- 0.71s
f5aas-gslb-prepare-subscription : retrieve result ---------------------------------------------------------------------------------------------------------------------- 0.71s
f5aas-gslb-prepare-subscription : prepare the proximity rule JSON object, copy the template file ----------------------------------------------------------------------- 0.70s

```

**Verify F5 Cloud Service**
Log into F5 Cloud Service, and verify that:
- service *gslb.thebizdevops.net* is created
- dRouter *aws1-az1* is added to the DNS load balancer pool

![gslb-service](images/gslb-service)
![gslb-pool](images/gslb-pool)

**Verify application**
Verify that the application is directed to Blue app (in our case, it shows OpenShift 4.2)
![app1-1](images/app1-1)

## Step 2: Test Route to Green (Optional)

Now that both apps are up and running, we will switch the router so all incoming requests go to the Green app and the Blue app, as shown below:

![blue](./images/blue-green)

**Retrieve route from Green**

Retrieve the routes of project “default" from the Green deployment
```
./project-retrieve default aws2-az1
 ```

This command retrieves all the routes of the given project/namespace ("default") and the specified dRouter, ands store this information in the desired GSLB store.

Now, we have both Blue and Green routes in GSLB store.

**Set the traffic ratio**

Set the GSLB ratio for each deployment for a given project/namespace ("default"). 
```
 ./project-ratios default '{"aws1-az1": "90", "aws2-az1": "10" }'
 ```
 We are setting the ratio to steer 90% of the traffic to Blue or "aws1-az1", and 10% to Green or "aws12-az1".

**Publish route to F5 Cloud Service**
Next, we can submit this configuration into F5 Cloud Service with the *gslb-commit* command. 

**Verify F5 Cloud Service**

After *gslb-commit* :

- F5 Cloud Service continues sending traffic for app1.thebizdevops.net to Green.
- Within a few seconds, F5 Cloud Service begins load balancing traffic between Blue (in our case, the app shows OpenShift 4.2) and Green (it shows OpenShift 4.3).

![gslb-pool2](images/gslb-pool2)


![app1-1](images/app1-1)
![app1-2](images/app1-2)

We can run a shell script to verify the traffic ratio:
```bash
./demo.sh
Password:

  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 37455  100 37455    0     0   9209      0  0:00:04  0:00:04 --:--:--  9211
    <h1>Welcome to your static nginx application on OpenShift 4.2</h1>
-------------Client  1 -----------
===================================

  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 37455  100 37455    0     0  94108      0 --:--:-- --:--:-- --:--:-- 93872
    <h1>Welcome to your static nginx application on OpenShift 4.2</h1>
-------------Client  2 -----------
===================================

  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 37455  100 37455    0     0  97793      0 --:--:-- --:--:-- --:--:-- 97793
    <h1>Welcome to your static nginx application on OpenShift 4.2</h1>
-------------Client  3 -----------
===================================

  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 37455  100 37455    0     0  98307      0 --:--:-- --:--:-- --:--:-- 98307
    <h1>Welcome to your static nginx application on OpenShift 4.2</h1>
-------------Client  4 -----------
===================================

  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 37455  100 37455    0     0    98k      0 --:--:-- --:--:-- --:--:--   98k
    <h1>Welcome to your static nginx application on OpenShift 4.2</h1>
-------------Client  5 -----------
===================================

  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 37455  100 37455    0     0  96533      0 --:--:-- --:--:-- --:--:-- 96533
    <h1>Welcome to your static nginx application on OpenShift 4.2</h1>
-------------Client  6 -----------
===================================

  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 37455  100 37455    0     0  99880      0 --:--:-- --:--:-- --:--:-- 99614
    <h1>Welcome to your static nginx application on OpenShift 4.3</h1>
-------------Client  7 -----------
===================================

```

## Step 3: Unmap Route to Blue
Once you verify Green is running as expected, stop routing requests to Blue.

![green1](./images/green1)

**Set the traffic ratio**

```
 ./project-ratios default '{"aws1-az1": "0", "aws2-az1": "100" }'
 ```

**Publish route to F5 Cloud Service**
Next, we can submit this configuration into F5 Cloud Service with the *gslb-commit* command. 
![gslb-pool3](images/gslb-pool3)

F5 Cloud Service stops sending traffic to Blue. Now all traffic for app1.thebizdevops.net is sent to Green.

![app1-22](images/app1-22)
