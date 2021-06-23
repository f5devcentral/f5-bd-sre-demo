# SRE Blue-Green Deployment with F5 and OpenShift
## Summary
The Site Reliability Engineering or SRE demo will be centered around three distinct customer driven use cases. This lab will take you through setting up one of the 3 use cases: Bule-Green Deployment  .

## Design

Demonstrate F5’s Blue-Green Deployment by using F5 Cloud Services, to minimise downtime as customer migrate application to new clusters, or from on-prem to off-prem.

![E2E Architecture](images/bluegreentopology)


## Understanding Blue Green Deployment
Blue-green deployment is a technique that reduces downtime and risk by running two identical production environments called Blue (or old OpenShift Cluster) and Green (new OpenShift Cluster).

As you prepare a new version of your software, deployment and the final stage of testing takes place in the environment that is not live: in this example, Green (or new OpenShift Cluster). Once you have deployed and fully tested the software in Green, you switch the router so all incoming requests now go to Green instead of Blue. Green is now live, and Blue is idle.

This technique can eliminate downtime due to app deployment. In addition, blue-green deployment reduces risk: if something unexpected happens with your new version on Green, you can immediately roll back to the last version by switching back to Blue.

## Prerequisites
- Two running OpenShift Clusters (for thie demo, we are running two clusters in AWS)
- Enterprise DNS in place (for this demo, we are running AWS Route53)
- Access to F5 Cloud Services (GSLB)
- Ansible installed

Please note that if, all of the prerequisites from the main readme page have not yet been configured please return to that page until they have been completed.

Also note that in this demo we are using a GSLB tool, which allows the automatic creation of GSLB DNS entries in [F5 CloudServices](https://clouddocs.f5.com/cloud-services/latest/)' DNS LB service.  Please refer to [GSLB tool project page](https://github.com/f5devcentral/f5-bd-gslb-tool) for details of the tool.

## Setup and Configuration
Follow the links below in order to begin setup and configuration.

1. [Getting familiar with F5 GSLB tool](https://github.com/f5devcentral/f5-bd-gslb-tool)
2. [Setting up DNS for F5 Cloud Services](https://github.com/f5devcentral/f5-bd-gslb-tool/wiki/Infrastucture-setup)
3. [Setting up GSLB tool](./gslb-setup.md)
4. [Building and Running the Blue-green Deployment](blue-green.md)
5. [Troubleshooting and FAQ](troubleshooting.md)


## Support

This project is a community effort to promote F5 container ingress service automation and is maintained by F5 BD. For any feature requests or issues, feel free to open an issue and we will give our best effort to address it



