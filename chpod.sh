#!/bin/bash

function helpMsg()
{
    echo;echo "Usage: $0 [ namespace name ]";echo
    exit 1
}

namespace=$1
err_pods=0
restart_pods=0
total_pods=-1

if [ $# -ne 1 ]; then
    helpMsg
fi

which kubectl > /dev/null
if [ $? -eq 1 ]; then
    echo;echo "[!] 'kubectl' not found.";echo
    exit 1
fi

kubectl get pods -n $namespace > /tmp/pods_$$
if [ $? -eq 1 ]; then
    echo;echo "[!] Failed to retrieve pods in $namespace.";echo
    exit 1
fi
file="/tmp/pods_$$"

printf "\n[*] Scanning Microservices on: $namespace ...\n\n"
while read line; do
    let total_pods++
    status=$(echo $line | awk '{ print $3}')
    restarts=$(echo $line | awk '{ print $4 }')
    if [ "STATUS" != $status ] && [ "Running" != $status ]; then
        let err_pods++
        pod_name=$(echo $line | awk '{ print $1 }')
        pod_status=$(echo $line | awk '{ print $3 }') 

        printf "\n[!] Microservice: $pod_name\n    Status:       $pod_status\n--- --- --- --- --- --- --- --- --- --- --- ---\n"
    elif [[ $restarts -ne "0" ]]; then
        let restart_pods++
    fi
done < $file
rm -f $file

printf "\n[*] Results\n[+] Running: $total_pods\n[+] Restarting: $restart_pods\n[+] Failing: $err_pods\n\n"

