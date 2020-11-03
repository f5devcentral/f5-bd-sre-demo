## Configuring the 'Watcher' and 'Logstash' of Elasticsearch

1. Configuring the 'Watcher' of Kibana
- You need an Elastic Platinum license or Eval license to use this feature on the Kibana. 
- Go to Kibana UI. 
- Management -> Watcher -> Create -> Create advanced watcher
- Copy and paste below JSON code

```
watcher_ocp.json

{
  "trigger": {
    "schedule": {
      "interval": "1m"
    }
  },
  "input": {
    "search": {
      "request": {
        "search_type": "query_then_fetch",
        "indices": [
          "nginx-*"
        ],
        "rest_total_hits_as_int": true,
        "body": {
          "query": {
            "bool": {
              "must": [
                {
                  "match": {
                    "outcome_reason": "SECURITY_WAF_VIOLATION"
                  }
                },
                {
                  "match": {
                    "x_forwarded_for_header_value": "N/A"
                  }
                },
                {
                  "range": {
                    "@timestamp": {
                      "gte": "now-1h",
                      "lte": "now"
                    }
                  }
                }
              ]
            }
          }
        }
      }
    }
  },
  "condition": {
    "compare": {
      "ctx.payload.hits.total": {
        "gt": 0
      }
    }
  },
  "actions": {
    "logstash_logging": {
      "webhook": {
        "scheme": "http",
        "host": "localhost",
        "port": 1234,
        "method": "post",
        "path": "/{{watch_id}}",
        "params": {},
        "headers": {},
        "body": "{{ctx.payload.hits.hits.0._source.ip_client}}"
      }
    },
    "logstash_exec": {
      "webhook": {
        "scheme": "http",
        "host": "localhost",
        "port": 9001,
        "method": "post",
        "path": "/{{watch_id}}",
        "params": {},
        "headers": {},
        "body": "{{ctx.payload.hits.hits[0].total}}"
      }
    }
  }
}
```

2. Configuring 'logstash.conf' file
Below is the final version of the 'logstash.conf' file.
*Please note that you have to start the logstash with 'sudo' privilege.*

```
logstash.conf

input {
    syslog {
        port => 5003
        type => nginx
        }

    http {
        port => 1234
        type => watcher1
        }

    http {
        port => 9001
        type => ansible1
        }
}

filter {
if [type] == "nginx" {
        
        grok {
            match => {
                "message" => [
                ",attack_type=\"%{DATA:attack_type}\"",
                ",blocking_exception_reason=\"%{DATA:blocking_exception_reason}\"",
                ",date_time=\"%{DATA:date_time}\"",
                ",dest_port=\"%{DATA:dest_port}\"",
                ",ip_client=\"%{DATA:ip_client}\"",
                ",is_truncated=\"%{DATA:is_truncated}\"",
                ",method=\"%{DATA:method}\"",
                ",policy_name=\"%{DATA:policy_name}\"",
                ",protocol=\"%{DATA:protocol}\"",
                ",request_status=\"%{DATA:request_status}\"",
                ",response_code=\"%{DATA:response_code}\"",
                ",severity=\"%{DATA:severity}\"",
                ",sig_cves=\"%{DATA:sig_cves}\"",
                ",sig_ids=\"%{DATA:sig_ids}\"",
                ",sig_names=\"%{DATA:sig_names}\"",
                ",sig_set_names=\"%{DATA:sig_set_names}\"",
                ",src_port=\"%{DATA:src_port}\"",
                ",sub_violations=\"%{DATA:sub_violations}\"",
                ",support_id=\"%{DATA:support_id}\"",
                ",unit_hostname=\"%{DATA:unit_hostname}\"",
                ",uri=\"%{DATA:uri}\"",
                ",violation_rating=\"%{DATA:violation_rating}\"",
                ",vs_name=\"%{DATA:vs_name}\"",
                ",x_forwarded_for_header_value=\"%{DATA:x_forwarded_for_header_value}\"",
                ",outcome=\"%{DATA:outcome}\"",
                ",outcome_reason=\"%{DATA:outcome_reason}\"",
                ",violations=\"%{DATA:violations}\"",
                ",violation_details=\"%{DATA:violation_details}\"",
                ",request=\"%{DATA:request}\""
                ]
        }
    break_on_match => false
  }
  
        mutate {
        split => { "attack_type" => "," }
        split => { "sig_ids" => "," }
        split => { "sig_names" => "," }
        split => { "sig_cves" => "," }
        split => { "staged_sig_ids" => "," }
        split => { "staged_sig_names" => "," }
        split => { "staged_sig_cves" => "," }
        split => { "sig_set_names" => "," }
        split => { "threat_campaign_names" => "," }
        split => { "staged_threat_campaign_names" => "," }
        split => { "violations" => "," }
        split => { "sub_violations" => "," }
  
        remove_field => [ "date_time", "message" ]
        }

        if [x_forwarded_for_header_value] != "N/A" {
                mutate { add_field => { "source_host" => "%{x_forwarded_for_header_value}"}}
                } else {
                        mutate { add_field => { "source_host" => "%{ip_client}"}}
                }
  
   geoip {
    source => "source_host"
    database => "/etc/logstash/GeoLite2-City.mmdb"
}
}
}

output {

if [type] == 'nginx' {
         elasticsearch {
                hosts => ["127.0.0.1:9200"]
                index => "nginx-%{+YYYY.MM.dd}"
        }
}

if [type] == 'watcher1' {
  file {
    path => "/yourpath/ip.txt"
    codec => line { format => "%{message}"}
  }
}

if [type] == 'ansible1' {
  exec {
          command => "ansible-playbook /yourpath/ansible_ocp.yaml"
  }
}
}
```



