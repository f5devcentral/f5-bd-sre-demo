# Setting up Book Info Application(s)

## Purpose
Book Info is a testing application that is published via the Istio project and a good example of a simplet multi microservice application.

This app will be used to demonstrate how to publish and update an application using the previously mentioned A/B Deployment method.

## Setup and Installation

1. From your bastion host open up an OC connection to the OpenShift Environment.
2. Once logged into the OpenShift CLI use the follwoing CLI to create a new project and deploy Book Info to the cluster.

### Login
```
oc login -u username -p password
```
### Create project 
```
oc new-project bookinfo
```

### OCP Permissions for Bookinfo
```
oc adm policy add-scc-to-user anyuid -z default -n bookinfo
oc adm policy add-scc-to-user privileged -z default -n bookinfo
```

### Deploy Bookinfo
```
oc apply -f https://raw.githubusercontent.com/generic-admin/yourrepohere/master/bookinfo.yaml
```

### Remove bookinfo
```
oc delete -f https://raw.githubusercontent.com/generic-admin/yourrepohere/master/bookinfo.yaml
```

### [Return to Index](README.md)

## Notes
Obviously the URLs above are placeholders you will need to fill in with you own, but just incase I figured I would call it out. It is perfectly ok to deploy this application to OpenShift at any time in the process prior to running the A/B Deployment automation task and leave it running.
