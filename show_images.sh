#!/bin/bash

export KUBECONFIG=../kubeconfig-cloudflared

echo
echo "Loading containers of pods in production namespace..."
echo
(
   # Column header and separator
   echo "CUSTOMER SERVICE EXCHANGE BASE QUOTE OBJECTIVE IMAGE1 IMAGE2" | column -t
   echo "------------------- "---------- "------------------ "------------- "---------- "---------- "------------------------------ "------------------------------ | column -t
   
   # Retrieve the list of pods in production namespace
   kubectl get pods -n production -o jsonpath='{range .items[*]}{"\n"}{.metadata.name}{" - "}{range .spec.containers[*]}{.image}{" "}{end}{end}' |
   
   # Exclude specific lines from the previous kubectl command output
   grep -v "pgbouncer\|postgres\|controller\|backend\|submit-dd-metrics\|toolbox" |
   
   # Separate output using '-' delimiter and print specific columns
   awk -F'-' '{print $2, $3, $4, $5, $6, $7, $9, $10}' |
   
   # Sort alphabetically in descending order by customer name
   sort -k1
   
) | column -t
echo
