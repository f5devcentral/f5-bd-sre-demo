#!/bin/bash

while [ 1 ]
do
        UserAgent=('Mozilla/5.0' 'AppleWebKit/537.36' 'Chrome/75.0.3770.142' 'Safari/537.36' 'Mozilla/5.5 Gecko' 'Firefox/40.0' 'Internet Explorer' 'Mozilla/5.0' 'AppleWebKit/605.1.15' 'Safari/604.1' 'Mozilla/5.3' 'AppleWebKit/537.36' 'Chrome/62.0' 'Mobile Safari/537.36' 'Opera 2.0' )

        seed=`echo "$(od -An -N4 -tu4 /dev/urandom) % 6" | bc`
        ua=${UserAgent[`echo "$seed % 4" | bc`]}

        curl -k -H "user-agent: $ua" https://bookinfo.example.com
        curl -k -H "user-agent: $ua" https://bookinfo.example.com/productpage
        curl -k -H "user-agent: $ua" https://bookinfo.example.com/productpage?u=normal 
        curl -k -H "user-agent: $ua" https://bookinfo.example.com/productpage?u=test
        sleep 2
done
