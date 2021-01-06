# Getting Started

## Summary
Canary deployment is an S/W releasing technique to reduce the risk of introducing new features or a new version in production for the DevOps team. In our SRE demo series, we already introduced how our customers easily can release their new S/W version with minimum risk using the canary deployment model. You can find more details of 'SRE Canary Deployment' use-case in [here](sre-usecases/01-targeted-canary/README.md).
In this use-case, we've enhanced our existing canary deployment use-case with F5 APM(Access Policy Manager), NGINX+, Microsoft Azure AD, and Red Hat OpenShift. You can learn how F5 components help to apply canary deployment in your containerized environment in this demo.

## Prerequisites
- BIG-IP APM and NGINX+ already installed
- Running OpenShift Cluster (3.11 used in this demo) 
- Must complete to install F5 CIS, bookinfo application and NGINX+ (You can find the installation steps in [here](sre-usecases/01-targeted-canary/README.md).

## Use Case Scenario
This use case is to demonstrate the concept of Targeted Canary Deployment for two user groups - 'F5 employee' and 'Non-F5 employee':

1. Developer can promote and target new versions of the same microservice (v1,v2,v3) to targeted users (Group1-F5 employee / Group2-nonF5 employee) respectively, without involving and waiting for the infrastructure operations team (NoOps).
2. BIG-IP APM in N-S will authenticate users through the interaction with an external MS Azure AD B2C service using OAuth. 
3. Once the user is authenticated successfully by MS Azure AD, Azure AD sends the user-specific information through JWT(JSON Web Token). 
4. After APM receives the token from the Azure AD, then it creates a new JWT and passes it to the backend NGINX+.
5. Once the NGINX+ receives the token, it extracts the user data and direct users to the correct microservice version based on the policy.

![demo flow](images/enhanced_1-1.png)

## Configuration Steps

## 1. Configuring Microsoft Azure AD B2C
![step-1](images/Slide6.jpeg)
![step-2](images/Slide7.jpeg)
![step-3](images/Slide8.jpeg)
![step-4](images/Slide9.jpeg)
![step-5](images/Slide10.jpeg)
![step-6](images/Slide11.jpeg)
![step-7](images/Slide12.jpeg)
![step-8](images/Slide13.jpeg)
![step-9](images/Slide14.jpeg)
![step-10](images/Slide15.jpeg)
![step-11](images/Slide16.jpeg)
![step-12](images/Slide17.jpeg)
![step-13](images/Slide18.jpeg)
![step-14](images/Slide19.jpeg)
![step-15](images/Slide20.jpeg)
![step-16](images/Slide21.jpeg)
![step-17](images/Slide22.jpeg)
![step-18](images/Slide23.jpeg)
![step-19](images/Slide24.jpeg)
![step-20](images/Slide25.jpeg)
![step-21](images/Slide26.jpeg)
![step-22](images/Slide27.jpeg)

## 2. Configuring F5 APM(Access Policy Manager)
![step-1](images/Slide29.jpeg)
![step-2](images/Slide30.jpeg)
![step-3](images/Slide31.jpeg)
![step-4](images/Slide32.jpeg)
![step-5](images/Slide33.jpeg)
![step-6](images/Slide34.jpeg)
![step-7](images/Slide35.jpeg)
![step-8](images/Slide36.jpeg)
![step-9](images/Slide37.jpeg)
![step-10](images/Slide38.jpeg)
![step-11](images/Slide39.jpeg)
![step-12](images/Slide40.jpeg)
![step-13](images/Slide41.jpeg)
![step-14](images/Slide42.jpeg)
![step-15](images/Slide43.jpeg)

## 3. Configuring NGINX Plus
![step-1](images/Slide45.jpeg)

## 4. Verifying Result
![step-1](images/Slide47.jpeg)
![step-2](images/Slide48.jpeg)
![step-3](images/Slide49.jpeg)
![step-4](images/Slide50.jpg)
![step-5](images/Slide51.jpeg)
![step-6](images/Slide52.jpeg)


