# F5 Beacon SRE Demo

[![license](https://img.shields.io/github/license/:merps/:f5-ts-sumo.svg)](LICENSE)
[![standard-readme compliant](https://img.shields.io/badge/readme%20style-standard-brightgreen.svg?style=flat-square)](https://github.com/RichardLitt/standard-readme)

This document covers the initial setup and configuration of the SRE Demo as demonstrated on the most recent webinar.

## Table of Contents

- [Security](#security)
- [Background](#background)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
    - [Beacon](#beacon)
    - [DataDog](#datadog)
    - [BIG-IP](#big-ip)
    - [NGINX+](#ngnix)
- [Configuration](#configuration)
    - [Beacon](#beacon)
    - [DataDog](#datadog)
    - [BIG-IP](#big-ip)
    - [NGINX+](#ngnix)
- [Usage](#usage)
- [API](#api)
- [Contributing](#contributing)
- [License](#license)

## Security

F5 Telemetry Streaming services (TS) operate over HTTPS using OAuth2 authorisation.

## Background

This is a How To Guide to replicate, with references to the underlying infrastructure of additional testing would 
like to be explored, this will cover just the steps required to complete configuration for NGINX+, BIG-IP & F5aaS Beacon.

## Prerequisites

To support this deployment pattern the following components are required:

* [F5 Cloud Services Portal](https://portal.cloudservices.f5.com/) Account
* [DataDog](https://www.datadoghq.com/free-datadog-trial/) Account
* F5 BIG-IP (physical or VE)
* NGINX+ Instance
* F5 Toolchain Components:
* [F5 Application Services v3 (AS3)](https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/)
* [F5 Telemetry Streaming (TS)](https://clouddocs.f5.com/products/extensions/f5-telemetry-streaming/latest/)
* [Postman](https://www.postman.com/)

***Optional***

If there is the desire to install the full demo stack the additional tools/accounts are suggested:

* [Terraform CLI](https://www.terraform.io/docs/cli-index.html)
* [git](https://git-scm.com/)
* [AWS CLI](https://aws.amazon.com/cli/) access.
* [AWS Access Credentials](https://docs.aws.amazon.com/general/latest/gr/aws-security-credentials.html)

## Installation 

This section covers the configuration for the deployment of the example application as demonstrated in the recent
Beacon webinar. This flow is built around the assumed deployment pattern that is similar to [F5-SRE-Demo](https://github.com/merps/f5-sre-demo),
the additional steps required for that deployment to replicate the webinar environment are contained in the [Configuration](#configuration) 
section of this How To.

Initially the sign-up for both F5 CloudServices and DataDog Trial account for the purpose of testing is covered here in this section, DataDog
Agents are a technical requirement at time of writing as Telemetry Streaming is not support with NGINX+.

### *Beacon*

F5 Beacon is a Cloud Services SaaS offering that provides both insights and analytics, this [demonstration](https://youtu.be/j81wsUgwFFI) video
provides a greater understanding of Beacon's current capabilities.

Also, as it coincides with this demo Beacon also has a 45 free day trial period so you may use and explore how Beacon provides insights to 
organisational needs. 

[Work with F5 Beacon](https://clouddocs.f5.com/cloud-services/latest/f5-cloud-services-Beacon-WorkWith.html) to explore many additional resources outside of this SRE Demo How To.

Sign up for you trial Beacon account, along with other F5 Cloud Services offerings at [F5 Cloud Services](https://https://portal.cloudservices.f5.com/)


### *DataDog*

Explore your stack with a free [Datadog trial](https://www.datadoghq.com/free-datadog-trial/), try Datadog for 14 days and learn how seamlessly uniting metrics, traces, and logs in one platform improves agility, increases efficiency, and provides end-to-end visibility across your entire stack.

DataDog insights and metrics are used in combination with NGINX+ provides logs and metrics of the instances used in this demo.

### *BIG-IP*

The deployment environment used for development is covered in detail [F5 SRE Demo](https://github.com/merps/f5-sre-demo),
this is a AWS Deployment example of Auto-scaling AWAF. For simplicity, steps replicate this deployment are as follows;

***a)*** First, clone the repo:
```
git clone https://github.com/merps/f5-sre-demo.git
```

***b)*** Second, create a [tfvars](https://www.terraform.io/docs/configuration/variables.html) file in the following format to deploy the environment;

#### Inputs
Name | Description | Type | Default | Required
---|---|---|---|---
cidr | CIDR Range for VPC | String | *NA* | **Yes**
region | AWS Deployment Region | String | *NA* | **Yes**
azs | AWS Availability Zones | List | *NA* | **Yes** 
secops-profile | Security Operations AWS Profile | String | `default` | **Yes**
customer | Customer/Client Short name used for AWS Tag/Naming | String | `customer` | No
environment | Environment Short name name used for AWS Tag/Naming | String | `demo` | No
project | Project Short name name used for AWS Tag/Naming | String | `project` | No
ec2_key_name | EC2 Key-pair for Instance Creation | String | *NA* | **Yes**

***c)*** Third, initialise and plan the Terraform deployment as follows:
```
cd f5-sre-demo/
terraform init
terraform plan --vars-file ../variables.tfvars
```

this will produce and display the deployment plan using the previously created `varibles.tfvars` file.

***d)*** Then finally to deploy the successfully plan;
```
terraform apply --vars-file ../variables.tfvars
```

> **_NOTE:_** This architecture deploys two c4.2xlage PAYG BIG-IP Marketplace instances, it is 
recommended to perform a `terraform destroy` to not incur excessive usage costs outside of free tier.

This deployment also covers the provisioning of the additional F5 prerequisite components so required for 
deployment example covered in the [F5 SRE Demo](https://github.com/merps/f5-sre-demo)

### *NGINX*

As with the installation of BIG-IP, this How To is based on that deployment. To replicate this deployment please 
refer to the well documented process of [Deploying NGINX and NGINX Plus on Docker](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-docker/) otherwise the steps outlined in the [Configuration](#configuration) section outline what is required for a WordPress 

As with other products and services, NGINX+ also offers a free license period that you can request [here](https://www.nginx.com/free-trial-request/ "Trial Request") where you can also trial additional modules of NGNIX+

## Configuration

### BIG-IP

As with DataDog, detailed instructions for the deployment and configuration for TS is located at [F5 Telemetry Streaming](https://clouddocs.f5.com/products/extensions/f5-telemetry-streaming/latest/).

As previously, steps to configure;

1. Update TS declarations as this example;

```
{
    "class": "Telemetry",
    "TS_System": {
        "class": "Telemetry_System",
        "systemPoller": {
            "interval": 60,
            "enable": true,
            "trace": false,
            "actions": [
                {
                    "setTag": {
                        "tenant": "`T`",
                        "application": "`A`"
                    },
                    "enable": true
                }
            ]
        },
        "enable": true,
        "trace": false,
        "host": "localhost",
        "port": 8100,
        "protocol": "http"
    },
    "TS_Listener": {
        "class": "Telemetry_Listener",
        "port": 6514,
        "enable": true,
        "trace": false,
        "match": "",
        "actions": [
            {
                "setTag": {
                    "tenant": "`T`",
                    "application": "`A`"
                },
                "enable": true
            }
        ]
    },
    "Poller":{ 
       "class":"Telemetry_System_Poller",
       "interval":60,
       "enable":true,
       "trace":false,
       "allowSelfSignedCert":false,
       "host":"localhost",
       "port":8100,
       "protocol":"http"
    },
    "Beacon_Consumer":{ 
        "class":"Telemetry_Consumer",
        "type":"Generic_HTTP",
        "host":"ingestion.ovr.prd.f5aas.com",
        "protocol":"https",
        "port":50443,
        "path":"/beacon/v1/ingest-telemetry-streaming",
        "method":"POST",
        "enable":true,
        "trace":false,
        "headers":[ 
           { 
            "name":"grpc-metadata-x-f5-ingestion-token",
            "value":"`>@/passphrase`"
           }
        ],
        "passphrase":{ 
            "cipherText":"a-aacnmyWgmu#C9zyugUVIZ4ywhhGSKh2o5BoZ3g12ZB1GJdhvW2yOIU="
        }
    }
    "schemaVersion": "1.6.0"    
}: "1.6.0" 
}
```
3. Push updated TS declaration to BIG-IP.


### DataDog

The configuration component is divided into two sections, [Docker Agent](http://docs.datadoghq.com/agent/docker) and the associated metrics. 

### Beacon

The deployment of the WordPress NGINX+ Docker example is documented and deployed with use of the deployment pattern as described within [F5 SRE Demo](https://github/merps/f5-sre-demo) where the application is deployed via API.

For the purpose of this How To, it will use the [F5 Beacon API](https://clouddocs.f5.com/cloud-services/latest/f5-cloud-services-Beacon-API.html) Postman collection 

### NGINX+ 

For both ease and simplicity, this section builds upon the Docker deployment with the use of a docker-compose, this detailed in [wordpress-nginx-docker-compose](https://github.com/merps/wordpress-nginx-docker-compose)

# Usage

### As per TODO 

## API

### As per TODO

## TODO

List of task to make the process my automated;

- [ ] Push updated SRE code as per Docker Compose refactor
- [ ] Workflow improvements for DO/AS3/TS
- [ ] Quick Snippets for Docker Compose Spin Up.

## Contributing

See [the contributing file](CONTRIBUTING.md)!

PRs accepted.

## Filing issues

If you find an issue, we would love to hear about it. You have a choice when it comes to filing issues:

- Use the [Issues link](https://github.com/f5devcentral/f5-bd-sre-demo/issues) on the GitHub menu bar in this repository for items such as enhancement or feature requests and non-urgent bug fixes. Tell us as much as you can about what you found and how you found it.

### ChangeLog

**2020-00-17**

- Corrected Use Casefolder path

**2020-06-16**

- Initial merge to [f5devcentral](https://github.com/f5devcentral/f5-bd-sre-demo) from [F5-SRE-HowTo](https://github.com/merps/f5-sre-howto)

## License

[Apache © merps.](../LICENSE)