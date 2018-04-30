#!/bin/bash

# This script needs Microsoft Azure Cli installed.

# Positional cli args:
# 1: Username 
# 2: Hostname

#cp cloud-init-form.txt cloud-init-temp.txt
PUBLIC_KEY=`cat ~/.ssh/id_rsa.pub`

# set public key
sed 's%PUBLIC_KEY%'"$PUBLIC_KEY"'%' <cloud-init-form.txt >cloud-init-temp.txt

# set user and hostname from pos args
sed -i 's/USERNAME/'"${1?"Username missing. Usage: deploy_vim USERNAME HOSTNAME"}"'/g' cloud-init-temp.txt
sed -i 's/HOSTNAME/'"${2?"Hostname missing. Usage: deploy_vim USERNAME HOSTNAME"}"'/g' cloud-init-temp.txt


# Create resource group if it does not exist yet
if [ `az group exists -n containerBenchGroup` = false ]
then
    echo "Creating resource group..."
    az group create --name containerBenchGroup --location eastus
    echo "...done."
fi

# Launch VM into resource group
echo "Trying to deploy Virtual Machine..."
az vm create \
    --resource-group containerBenchGroup \
    --name "$2" \
    --image canonical:UbuntuServer:16.04-LTS:latest \
    --generate-ssh-keys \
    --custom-data cloud-init-temp.txt

echo "Removing temp files..."
rm ./cloud-init-temp.txt
echo "...done."

echo "NOTE: Compiling and installation of Singularity"
echo "will take some minutes from now and might not"
echo "be available directly after immediate login."
