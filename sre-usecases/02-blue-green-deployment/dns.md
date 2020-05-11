### 2. DNS Setup

An Openshift cluster typically has its own domain, for the applications, for example:
```
*.apps.<cluster name>.mycompany.com
```
On the other hand end users don’t use such long names for the applications and instead they would use instead:
```
www.mycompany.com
```
where www is typically reachable in the cluster as www.<apps>.<mycluster>.mycompany.com as well.

This scenario is typically setup as follows in DNS:

|DNS zone/name |	Description |
|---------------------------------------------------------- |:--------------------------|
|mycompany.com	| Usually hosted in corporate DNS, possibly in a Cloud DNS. |
|Application’s main DNS names such as www.mycompany.com	| CNAME records pointing to A records of the cluster. Following the example www.apps.<cluster name>.mycompany.com |
|<cluster>.mycompany.com	| Usually delegated to cluster DNS. |


A DNS request performs the following steps for its resolution:
 
In the case the customer has several clusters the application’s main DNS names will contain CNAME records for each cluster, possibly weighted round robin. This type of solutions lack:
-	Comprehensive health checking monitoring.
-	Automation and integration with the Openshift cluster.
-	Ability to shift workloads across clusters swiftly.
F5 Cloud Services provides these features in an Anycast infrastructure around the globe with the ease of a Software As A Service solution which doesn’t require infrastructure modifications. This DNS
When using F5 Cloud Services’ DNS LB the DNS resolution will look as follows:
  

The overall DNS setup can be seen in the next diagram:

 
 

### 3. Delegating a subdomain to F5 Cloud Service

You can reference here for more inforation about F5 Cloud Services:
https://clouddocs.f5.com/cloud-services/latest/
https://clouddocs.f5.com/cloud-services/latest/f5-cloud-services-GSLB-FAQ.html

You can continue to manage DNS through your current provider and delegate a subdomain for which F5 Cloud Services will issue responses. Then you would create CNAME records on the primary DNS nameserver for any FQDNs you want to load balance, pointing to A records in the delegated subdomain. The process is more or less the same as with F5’s self-hosted product, BIG-IP DNS, and more instructions can be found here: https://support.f5.com/csp/article/K277



https://support.f5.com/csp/article/K277

1. Create a new subdomain for which the BIG-IP DNS or BIG-IP Link Controller system is authoritative.
   ex.  *ocp.thebizdevops.net*
2. Delegate authority for the entire subdomain to the F5 Cloud Service
   For example, to delegate authority for the ocp.thebizdevops.net subdomain to the F5 Cloud Service DNS systems named
   - ns1.f5cloudservices.com
   - ns2.f5cloudservices.com

```
host -t NS ocp.thebizdevops.net
ocp.thebizdevops.net name server ns1.f5cloudservices.com.
ocp.thebizdevops.net name server ns2.f5cloudservices.com.
```

AWS Route53 Sub-Domain Delegation
https://www.youtube.com/watch?v=nlff6mnmMeM
