#!/bin/bash

echo "Enabling CPU Manager and NUMA feature gates"

kubectl patch kubevirt kubevirt -n harvester-system --type='json' -p='[{"op": "add", "path": "/spec/configuration/developerConfiguration/featureGates/-", "value":"NUMA"}]'
kubectl patch kubevirt kubevirt -n harvester-system --type='json' -p='[{"op": "add", "path": "/spec/configuration/developerConfiguration/featureGates/-", "value":"CPUManager"}]'