# Getting Started - SRE ELK Stack Deployment 
## Summary
The ELK stack is a collection of three open source projects, namely Elasticsearch, Logstash and Kibana. The ELK stack provides IT project stakeholders the capabilities of multi-system and multi-application log aggregation and analysis. In addition, the ELK stack provides data visualization at stakeholders' fingertips, which is useful for security analytics, system monitoring and troubleshooting.

A brief description of the three projects. Based on the Apache Lucene search engine, Elasticsearch is an open source, full-text analysis and search engine. Logstash is a log aggregator that executes transformations on data derived from various input sources, before transfering it to output destinations. Kibana provides the data analysis and visualization capabilities for end-users, complementary to Elasticsearch.

In this demo, ELK is utilized for the analysis and visualization of application performance through a centralized dashboard. Through the dashboard, end-users can easily correlation for North-South traffic and East-West traffic.<br>

![ELK_Topolgy](images/elk_topology.png)<br>


## Prerequisites
### Setup the ELK server using these instructions: ( https://www.digitalocean.com/community/tutorials/how-to-install-elasticsearch-logstash-and-kibana-elastic-stack-on-ubuntu-18-04 ) The ELK stack resides outside the Red Hat OpenShift Container Platform cluster.
### Analyze and apply the Logstash configuration ![file](./logstash.conf) for this demo.


## Use case scenario
This use case is an extension of the earlier ![Use Case #1(targeted canary)](https://github.com/f5devcentral/f5-bd-sre-demo/tree/master/sre-usecases/01-targeted-canary). 

If you have completed Use Case #1, existing configurations exist in the Red Hat OpenShift Container Platform cluster, which inserts UUIDs into the HTTP header of the data packet. Using an iRule on BIG-IP, the UUID is generated and inserted into the HTTP header of every HTTP request packet arriving at BIG-IP.

All traffic access logs containing UUIDs are sent to the ELK server, for validation of information, like: user location, response time by user location, response time of BIG-IP and NGINX, etc.


## Setup and Configuration

### 1. Create HSL pool, iRule on BIG-IP<br>
 We need to create a High-Speed Logging (HSL) pool on BIG-IP, meant for use by the ELK Stack. The HSL pool is assigned to the **bookinfo** application.
<br>

*[NOTE] F5’s High Speed Logging (HSL) mechanism is designed to pump out as much data as can be readily consumed, with the least amount of overhead, to a pool of syslog listeners. As it happens, Elastic Stack is designed to consume data in high volume. The HSL template packs the information into a parsable string, perfect for Logstash to interpret.*
<br>
 
 This pool member will be used by ![iRules](./iRules) to send access logs from BIG-IP to the ELK server.<br>
![ELK_Pool](images/elk_pool.png)
<br>
 
_The ELK server is listening for incoming log analysis requests, at IP address 10.69.33.1 and port 8516 port._<br>
![ELK_Pool_Member](images/elk_pool_member.png)

_Next, create a new VIP for the **bookinfo** HSL pool which was created earlier._<br>
![ELK_VIP](images/elk_vip.png)
<br>
*[NOTE] The VIP is the destination (combination of IP and port) to which requests will be sent when bound for whatever application lives behind the BIG-IP.*
<br>

_Name the VIP, **bookinfo-EdgeGW**.
<br>

_Through BIG-IP console, assign **bookinfo** as the **Default Pool**. 
_The name of the applied iRule, for this VIP, is **elk_hsl_irule**. With this iRule, all access logs containing the respective UUID for the HTTP datagram, will be sent to the ELK server._<br>
![ELK_Default_Pool](images/elk_default_pool.png)
<br>

_Now, the ELK server is ready for the analysis of BIG-IP access logs. Configuration for the NGINX apps deployed on the Red Hat OpenShift Container Platform cluster exist in respective config map objects._<br>
![ELK_Log](images/elk_log.png)
<br><br><br>

### 2. Customize Kibana Dashboard<br>
If all configurations are in place, log information will be processed by the ELK server. You will be able to customize a dashboard containing useful, visualized data, likeuser location, response time by location, etc.<br>

The list of key indicators available on the Kibana dashboard page is rather long, so we won't describe all of the indicators here.<br>
Now, let us see how it works<br>

<br>_**(Step 1)** Launch the console to the ELK server( http://x.x.x.x:5601 ) in your favourite web browser. A Kibana landing page appears, like so. We will leave the study and analysis of those indicators to you at your own time._
![Kibana1_main](images/Kibana1_main.png)
<br>

<br>_**(Step 2)** From the side-menu on the left, click on the highlighted icon, and the **Management** page is displayed._
![Kibana2_management](images/Kibana2_management.png)
<br>

<br>_**(Step 3)** On the **Management** page, click on the link **Index Management**, and the **Index Management** page is displayed._
![Kibana3_management_detail](images/Kibana3_management_detail.png)
<br>

<br>_**(Step 4)** On the **Index Management** page, notice the indexes defined in the ![logstash.conf](./logstash.conf) file are displayed._
![Kibana4_index_management](images/Kibana4_index_management.png)
<br>_A guide to managing these indices is available_ ![here](https://www.elastic.co/guide/en/kibana/current/managing-indices.html)
<br>

<br>_**(Step 5)** Next, proceed to visualize the indexed data. From the side-menu on the left, click on the **Visualize** icon._
![Kibana5_visualize](images/Kibana5_visualize.png)
<br>

<br>_**(Step 6)** In the **New Visualization** pop-out window, select the **Coordinate Map** visualization._
![Kibana6_create](images/Kibana6_create.png)
<br>

<br>_**(Step 7)** In the **New Coordinate Map** pop-out window, select the **logstash-f5-nginx-access** data source._ 
![Kibana7_source](images/Kibana7_source.png)
<br>

<br>_**(Step 8)** In the **Metrics** section of the page, assign the following values to the visible fields: **Average** in the *Aggregation* field, **response_time_ms** in the *Field* field and *Response Time* in the **Custom label** field._ 
![Kibana8_Metrics](images/Kibana8_Metrics.png)
<br>

<br>_**(Step 9)** In the **Buckets** section of the page, click on the **+ Add** link. Assign the following values to the visible fields: **Geohash** in the *Aggregation* field, **geoip.location** in the *Field* field and *Locations* in the **Custom label** field._ 
![Kibana8_Bucktes](images/Kibana8_Buckets.png)
<br>

<br>_**(Step 10)** Apply your changes by clicking the icon highlighted in the diagram. Notice the dashboard is updated with visualized log traffic._ 
![Kibana9_apply](images/Kibana9_apply_save.png)
<br>

<br>_**(Step 11)** Save the visualization as **ASEAN_CES**._ 
![Kibana9_save](images/Kibana9_save_name.png)
<br>_Congratulations on creating your first data visualization! Repeat the steps you took to create as many visualizations as you wish._
<br>

<br>_**(Step 12)** Next, create a dashboard and add to it, the visualization you just created. From the side-menu on the left, click on the "Dashboard" icon._ 
![Kibana10_dashboard](images/Kibana10_dashboard.png)
<br>

<br>_**(Step 13)** On the **Dashboards** page, click on the "Create new dashboard" button._ 
![Kibana10_create](images/Kibana10_dashboard_create.png)
<br>

<br>_**(Step 14)** Click on the "Add" link. Notice that we will can now add visualizatons as panels. Add the **ASEAN_CES** visualization as a panel, by clicking on the respective link of the same name._
![Kibana10_add_panel](images/Kibana10_add_panel.png)
![Kibana10_choose_panel](images/Kibana10_select_panel.png)
<br>

<br>_**(Step 15)** The visualization **ASEAN_CES** is displayed on the dashboard. Repeat Steps 6 - 14 as many times as you need, to add more visualizations to the dashboard._ 
![Kibana10_save](images/Kibana10_dashboard_save.png)
<br>

<br>_**(Step 16)** Click the "Save" link. Type "ASEAN_CES_Dashboard" in the title field and click on the "Confirm Save" button below. _ 
![Kibana10_dashboard_name](images/Kibana10_dashboard_name.png)
![Kibana10_dashboard_final](images/Kibana10_dashboard_final.png)
<br>

<br>_**(Step 17)** Now, we are ready to monitor the visualization dashboard proper. Click on the "Dashboard" icon on the menu, and notice that the dashboard titled  "ASEAN_CES_Dashboard" appears in the list._
![Kibana11_move_dashboard](images/Kibana11_move_dashboard.png)
<br>

<br>_**(Step 18)** Click on the link "ASEAN_CES_Dashboard" and the dashboard launches, complete with visualized data. Click on the **Refresh** button located at the top right corner of the page. The visualization panel is now refreshed with the latest data from the log stream.
![Kibana11_dashboard_update](images/Kibana11_dashboard_update.png)
![Kibana11_dashboard_update](images/Kibana11_dashboard_refresh.png)
<br><br><br>

### 3. ELK Dashboard Sample
![ELK_Pool](images/elk_map.png)


![ELK_Pool](images/elk_bigip.png)


![ELK_Pool](images/elk_response.png)


![ELK_Pool](images/elk_dot.png)
