#!/bin/bash

# parse args
CONFIG_FILE=test_config.yaml
while [[ $# -gt 0 ]] && [[ "$1" == "--"* ]] ;
do
    opt="$1";
    shift;              
    case "$opt" in
        "--password" )
           PASSWORD="$1"; shift;;
        "--password="* )    
           PASSWORD="${opt#*=}";;
        "--vip" )
           VIP="$1"; shift;;
        "--vip="* )
           VIP="${opt#*=}";;
        *) echo >&2 "Invalid option: $@"; exit 1;;
   esac
done

# get token
TOKEN=$(curl -sk -X POST https://$VIP/v3-public/localProviders/local?action=login -H 'content-type: application/json' -d '{"username":"admin","password":"'$PASSWORD'"}' | jq -r '.token')
if [[ $TOKEN == "null" ]]; then
    echo "Failed to get token, is the password and VIP correct?"
fi

# get kubeconfig
curl -sk https://$VIP/v1/management.cattle.io.clusters/local?action=generateKubeconfig -H "Authorization: Bearer ${TOKEN}" -X POST -H 'content-type: application/json' | jq -r .config > config
chmod 600 config

echo "Set your KUBCONFIG environment variable:"
echo "export KUBECONFIG=$PWD/config"

