#!/bin/bash

NUMBER=$1
MESSAGE=$2

./session.sh
./token.sh

LENGTH=${#MESSAGE}
TIME=$(date +"%Y-%m-%d %T")
TOKEN=$(<token.txt)



USSD="<request><content>$NUMBER</content><codeType>CodeType</codeType><timeout></timeout></request>"

# echo $USSD

curl -b session.txt -c session.txt -H "X-Requested-With: XMLHttpRequest" --data "$USSD" http://192.168.8.1/api/ussd/send --header "__RequestVerificationToken: $TOKEN" --header "Content-Type:text/xml"  --silent > /dev/null

sleep 5

DATA="<request><PageIndex>1</PageIndex><ReadCount>1</ReadCount><BoxType>1</BoxType><SortType>0</SortType><Ascending>0</Ascending><UnreadPreferred>1</UnreadPreferred></request>"

curl -b session.txt -c session.txt -H "X-Requested-With: XMLHttpRequest" http://192.168.8.1/api/ussd/get --header "__RequestVerificationToken: $TOKEN" --header "Content-Type:text/xml" --silent | grep 'content>' | awk -F ">" '{print $2}' | awk -F "<" '{print $1}'
