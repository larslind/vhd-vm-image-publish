#!/bin/bash 
green="\e[0;92m"
bold="\e[1m"
reset="\e[0m"

echo -e "${green}${bold}"
echo -e "==================================================================================================================================================="
echo -e "This script creates a VM with an unmanaged disk and converts it to a generalised VHD image."
echo -e "The full instructions are available here: https://www.azurecitadel.com/marketplace/vmoffer/vmoffer-vm/#create-vm-using-sas-uri-approach-alternative"
echo -e "The SAS URL will be valid for 7 days"
echo -e "This script requires the Azure CLI. Please see https://aka.ms/azcli for details"
echo -e "==================================================================================================================================================="
echo -e "${reset}"


echo "Please enter the name of the Resource Group"
read rgName
echo "Please enter the Azure Region to deploy the resources to. Please use 'az account list-locations --output table' to find available locations."
read rgLocation
echo "Name of the VM"
read vmName
echo "Size of the VM. Recommend Standard_B1s for test deployments (low performance) and <TBC> for production deployments"
read vmSize
echo "Admin user name"
read adminUser
#
#
#az group create --name $rgName --location $rgLocation
#
#az vm create \
#   --resource-group $rgName \
#   --name $vmName \
#   --image 'Canonical:UbuntuServer:18.04-LTS:latest' \
#   --admin-username $adminUser \
#   --generate-ssh-keys \
#   --size $vmSize \
#   --use-unmanaged-disk

publicIps=$(az vm show --resource-group $rgName --name $vmName --show-details --query 'publicIps' --output tsv)
storageAccountName=$(az vm show --resource-group $rgName --name $vmName --query 'storageProfile.osDisk.vhd.uri' --output tsv | sed 's/https:\/\///' | sed 's/.blob.core.*//')
vhdFileName=$(az vm show --resource-group $rgName --name $vmName --query 'storageProfile.osDisk.vhd.uri' --output tsv | sed 's/.*windows.net\/vhds\///')

echo -e "${green}${bold}"
echo -e "==================================================================================================================================================="
echo -e "Now connect to the VM using the following command:"
echo -e "${reset}  ssh "$adminUser"@"$publicIps"${green}${bold}"
echo -e "Install the latest updates:"
echo -e "${reset}  sudo apt-get update && sudo apt-get upgrade -y${green}${bold}"
echo -e "*** Do any VM customisation required.***"
echo -e "While still logged in to the VM, run the following command to remove the Azure Linux agent:"
echo -e "${reset}  sudo waagent -verbose -deprovision+user${green}${bold}"
echo -e "Stop and deallocate the VM before copying the VHD file:"
echo -e "${reset}  az vm deallocate --resource-group "$rgName" --name "$vmName"${green}${bold}"
echo -e "The full instructions are available here: https://www.azurecitadel.com/marketplace/vmoffer/vmoffer-vm/#create-vm-using-sas-uri-approach-alternative"
echo -e "==================================================================================================================================================="
echo -e "Information required to generate SAS URL"
echo -e "  Storage Account name:"
echo -e "${reset}  "@storageAccountName"{green}${bold}"
echo -e "  VHD file name:"
echo -e "${reset}  "@vhdFileName"{green}${bold}"
echo -e "==================================================================================================================================================="
echo -e "${reset}"
