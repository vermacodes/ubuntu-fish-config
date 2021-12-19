#!/bin/bash
#
#
#
# ====================================================
#
# Author : vermacodes
# 
# CHANGE LOG
# 
# Update Date   : 11/30/2021
# Version       : v0.0.1
# Changes       : Initial Version
#
# Update Date   : 11/30/2021
# Version       : v0.0.2
# Changes       : 1. CLI default output for humans
#               : 2. Checking of user is logged in or else login again.
#               : 3. ensuring user logged in to VM and CLI are same
#               : 4. context names to make sense
# ====================================================
#
# 
#
#
# CLI Setup
#
# Setting default CLI output to table
az config set core.output=table
#
#
# CLI Login
az account show 1> /dev/null
if [ $? != 0 ]; then
  az login --use-device-code
fi
#
# ----------------------------------------------------
#
# Validations
# 
# Validates that logged in user is using the script
#
# ----------------------------------------------------
echo "Validating User..."
userLoggedIn="$(who am i | awk '{print $1}')"
aadUser="$(az ad signed-in-user show --output json | jq -r '.mailNickname')"

if [[ "${userLoggedIn}" != "${aadUser}" ]]; then
        while [[ "${userLoggedIn}" != "${aadUser}" ]]; do
                echo "Azure CLI login required..."
                az login --use-device-code
                read -p "Press any key to continue... " -n1 -s
                # Re-Validating User
                userLoggedIn="$(who am i | awk '{print $1}')"
                aadUser="$(az ad signed-in-user show --output json | jq -r '.mailNickname')"
        done
else
        echo "User validated succesfully..."
fi

# ----------------------------------------------------
# Set subscription
# ----------------------------------------------------
echo "Setting subsctiption to isaac non-prod..."
subscriptionId=$(curl -x "" -s -H Metadata:true 'http://169.254.169.254/metadata/instance?api-version=2019-08-15' | jq '.compute.subscriptionId' -r)
az account set --subscription ${subscriptionId}

# ----------------------------------------------------
# Get Location
# ----------------------------------------------------
location=$(curl -x "" -s -H Metadata:true 'http://169.254.169.254/metadata/instance?api-version=2019-08-15' | jq '.compute.location' -r)

# ----------------------------------------------------
# Pull list of all clusters in subscription
# ----------------------------------------------------
echo "Pulling list of all clusters..."
clusters+=($(az aks list --query '[].{Name:name, ResourceGroup:resourceGroup}' -o tsv | awk '{print $1 "|" $2}'))

# ----------------------------------------------------
# Pull credentials
# ----------------------------------------------------
for cluster in "${clusters[@]}"; do
        #
        # Only pulling credentials of v2 clusters
        #
        if [[ $cluster != *"$location"* ]]; then
                continue
        fi

        #
        # Splitting cluster name and resource group
        #
        name=$(echo $cluster | awk -F"|" '{print $1}')
        resourceGroup=$(echo $cluster | awk -F"|" '{print $2}')

        #
        # Getting env and tier names from cluster name
        #
        envName=$(echo $name | awk -F"-" '{print $5}')
        tierName=$(echo $name | awk -F"-" '{print $4}')
        region=$(echo $name | awk -F"-" '{print $4}')
        #
        # Pull credetials of admin user if asked
        # otherwise pull users credentails
        #
        echo "Pulling credentails for ${name}"
        if [[ "$1" == "admin" ]]; then
                az aks get-credentials --name $name --resource-group $resourceGroup --admin --overwrite-existing --context ${envName}-${tierName}
        else
                az aks get-credentials --name $name --resource-group $resourceGroup --overwrite-existing --context ${envName}-${tierName}
        fi
done
