# https://learn.microsoft.com/en-us/azure/developer/terraform/get-started-windows-bash?tabs=bash

# It is available at Azure Cloud Shell. Needs to be downloaded locally, if local run.
terraform -version

az account show

az account list --query "[?user.name=='<microsoft_account_email>'].{Name:name, ID:id, Default:isDefault}" --output Table
az account list --query "[?user.name=='live.com#guilhermeviegas1993@gmail.com'].{Name:name, ID:id, Default:isDefault}" --output Table

az account set --subscription "<subscription_id_or_subscription_name>"

az ad sp create-for-rbac --name <service_principal_name> --role Contributor --scopes /subscriptions/<subscription_id>
az ad sp create-for-rbac --name srvpri --role Contributor --scopes /subscriptions/acef547e-ac28-4be8-b6b4-6a240d96947c


# To download the provider API:
# Even within AZ it is necessary to initialize the depencency in the provider, in this case Azure (azurerm) itself.
terraform init

# 
terraform plan

#
# Declarative
terraform apply
terraform apply -auto-approve

#

# Connect to the VM through SSH:
# Verificar ssh -i      e senhas
# ssh <useradmin>@<public-IP-address>
ssh useradmin@20.195.160.36

# Authenticate with password;

# Upgrade the machine:
sudo apt update -y
# sudo apt upgrade -y

# Install Ubuntu desktop:
sudo apt install ubuntu-desktop -y

# Install and prepare xrdp (Graphical login):
sudo apt install xrdp -y
echo "lxsession -s Lubuntu -e LXDE" > ~/.session
sudo service xrdp restart

# ----------------------------------------------------

# Update the vmSize and storageAccountType:
az vm update \
  -g azvm4reasearch-rg \
  -n azvm4reasearch-vm \
  --set hardwareProfile.vmSize=Standard_F8s_v2

# Deallocate (stop) the VM:
az vm deallocate -g azvm4reasearch-rg -n azvm4reasearch-vm

# Update Disk size:
az disk update \
  -g azvm4reasearch-rg \
  -n azvm4reasearch-vm_OsDisk_1_92dbf2d473b849ab9b54e2c33c0df583 \
  --size-gb 512 \
  --sku Premium_LRS

az vm start \
-g azvm4reasearch-rg 
-n azvm4reasearch-vm

az vm generalize \
   -g azvm4reasearch-rg \
   -n azvm4reasearch-vm

az image create \
   -g azvm4reasearch-rg \
   -n azvm4reasearch-vm-img \
   --source azvm4reasearch-vm

az vm image list

az vm create \
  -g azvm4reasearch-rg \
  -n azvm4reasearch-vm4 \
  --image Canonical:UbuntuServer:18.04-LTS:latest \
  --admin-username useradmin \
  --admin-password Password123# \
  --generate-ssh-keys 
  --ssh-key-value /home/user/.ssh/id_rsa.pub

# "Publisher:Offer:Sku:Version"
/CommunityGalleries/{gallery_unique_name}/Images/{image}/Versions/{version}
