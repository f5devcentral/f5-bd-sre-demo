# SRE Multi-Cluster Container Platform

## Summary
This Site Reliability Engineering (or SRE) Multi-Cluster design is an F5 Alliances product showcase. It is initiated by the F5 Business Development organization.

## Goal

The Purpose of the Multi-Cluster SRE demo is to show how the F5 product portfolio (BIG-IP, [Container Ingress Services](https://github.com/F5Networks/k8s-bigip-ctlr),  NGINX+, and F5 Cloud Service) can be used in conjunction with several other F5 Alliances integrations to help an SRE deploy, manage and secure modern applications.


The Multi-Cluster SRE Design can be used:
- as a self learning tool to get familiar with OpenShift, and F5 technologies (BIG-IP, Container Ingress Services, NGINX, and F5 Cloud service etc.) 
- to build demos and proof of concepts (POC's)


## Prerequisites
Although the respective requirements vary for each use case, in general you will need several prerequisites in place to begin.

- Subscribe to F5 Beacon [Click here](Beacon%20Subscription.pdf)
- Access to git preferable a valid GitHub account
  - https://github.com/
- A minimum of two OpenShift clusters
  - https://docs.openshift.com/container-platform/
- Two Licensed BIG-IP VE appliances with Best licenses, one per cluster
  - https://f5.com/products/trials/product-trials/product-trial
- F5 Container Ingress Service - Installed
  - https://clouddocs.f5.com/containers/v2/openshift/
- Access to F5 Cloud Services (DNS Load Balancing)
  - https://portal.cloudservices.f5.com/



## Getting started

Once the necessary infrastructure and services are in place users will be able to go to each use case directory under [*sre-usecases*](sre-usecases), and follow  **README** for detailed implementation.

The SRE demo will be centered around the following distinct customer driven use cases:


- [Scenario Use Case #1: Blue Green Deployment with F5 Cloud Services](./sre-usecases/02-blue-green-deployment/README.md)
- [Scenario Use Case #2: Targeted Canary Deployment](sre-usecases/01-targeted-canary/README.md)
- [Scenario Use Case #3: Observability with ELK](sre-usecases/03-observability-for-targeted-canary-with-ELK /README.md)
- [Scenario Use Case #4: Observability with Beacon](sre-usecases/04-observability-for-code-to-customer-with-Beacon/README.md)
- [Scenario Use Case #5: North-South Traffic Protection in the OpenShift Environment](sre-usecases/05-north_south_protection/README.md)
- [Scenario Use Case #6: Protecting Critical Apps against East-West Attack](sre-usecases/06-east_west_attack/README.md)
- [Scenario Use Case #7: Enhanced Targeted Canary Deployment](sre-usecases/07-enhanced_targeted_canary/README.md)

This project is WIP, with more use cases to be added.

## Contribution

Please read [How to Contribute](CONTRIBUTING.md)

## Support

This project is a community effort to promote container ingress service automation and is maintained by F5 BD. For any feature requests or issues, feel free to open an issue and we will give our best effort to address it.
