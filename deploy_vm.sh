#!/bin/bash

# Check if we have a env variable set for a resource group
if [ $AZ_RESOURCE_GROUP ];
then
    echo "Deploying to \"$AZ_RESOURCE_GROUP\" Resource Group"
else
    echo "Deploying new Resource Group \"containerBenchGroup\" to East US"
    az group create --name containerBenchGroup --location eastus 
fi

