# SRE Multi-Cluster Design

## Summary
This Site Reliability Engineering or SRE Multi-Cluster is an F5 Alliances product showcase. It is built by F5 Business Development organization.

## Goal

The Purpose of the Multi-Cluster  SRE demo is to show how F5 product portfolio (BIG-IP, [Container Ingress Services](https://github.com/F5Networks/k8s-bigip-ctlr),  NGINX+, and F5 Cloud Service) can be used in conjunction with several other F5 Alliances integrations to help SRE deploy, manage and secure modern applications.


The Multi-Cluster SRE Design can be used:
- as a self learning tool to get familiar with OpenShift & Container Ingress Services for F5 BIG-IP
- to build demos and proof of concepts (POC)


## Prerequisites
Although the respective requirements vary for each use case, in general you will need several prerequisites in place to begin.

- Access to git preferable a valid GitHub account
  - https://github.com/
- A minimum of two OpenShift clusters
  - https://docs.openshift.com/container-platform/
- Two Licensed BIG-IP VE appliances with Best licenses, one per cluster
  - https://f5.com/products/trials/product-trials/product-trial
- F5 Container Ingress Service - Installed
  - https://clouddocs.f5.com/containers/v2/openshift/
- Access to F5 Cloud Services (DNS Load Balancing)
  - https://www.f5.com/products/ways-to-deploy/cloud-services/preview


## Getting started

Once the necessary servers and infrastructure are in place users will be able to go to each use case directory under [*sre-usecases*](sre-usecases), and follow  **README** for detailed implementation.

The SRE demo will be centered around # distinct customer driven use cases. 

- [Scenario Use Case #1: Targeted Canary Deployment](sre-usecases/01-targeted-canary/README.md)
- [Scenario Use Case #2: Blue Green Deployment with F5 Cloud Services](./sre-usecases/02-blue-green-deployment/README.md)

This project is WIP, with more use cases to be added.

## Support

This project is a community effort to promote container ingress service automation and is maintained by F5 BD. For any feature requests or issues, feel free to open an issue and we will give our best effort to address it.