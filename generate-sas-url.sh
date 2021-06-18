#!/bin/bash 
green="\e[0;92m"
bold="\e[1m"
reset="\e[0m"


echo "Please enter the source VHD storage account name"
read sourceStorageAccountName
echo "Please enter the name of the source VHD file"
read sourceVHDFileName

end=`date -u -d "7 days" '+%Y-%m-%dT%H:%MZ'`
sourceSAS=`az storage container generate-sas --account-name $sourceStorageAccountName --name vhds --https-only --permissions lr --expiry $end -o tsv`
sourceVHDSASURL="https://"$sourceStorageAccountName".blob.core.windows.net/vhds/"$sourceVHDFileName"?"$sourceSAS

echo -e "${green}${bold}"
echo -e "============================================================================================================="
echo -e "SAS URL to share with customer to copy VHD:"
echo -e $sourceVHDSASURL
echo -e "Expires: "$end" UTC"
echo -e "============================================================================================================="
echo -e "${reset}"
