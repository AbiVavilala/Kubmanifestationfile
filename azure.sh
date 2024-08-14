ResourceGroup=rg-lab
VnetName=vnet-hub
VnetPrefix=10.0.0.0/16
SubnetName=vnet-hub-subnet1
SubnetPrefix=10.0.1.0/24
Location=westus2

# Run the command to create a virtual network vnet-hub, with one subnet vnet-hub-subnet1.

az network vnet create -g $ResourceGroup -n $VnetName --address-prefix $VnetPrefix --subnet-name $SubnetName --subnet-prefix $SubnetPrefix -l $Location

# Create the NSG and security rule

Nsg=nsg-hub
NsgRuleName=vnet-hub-allow-ssh
DestinationAddressPrefix=10.0.1.0/24
DestinationPortRange=22

# Create the Network Security Group and add the security rule

az network nsg create --name $Nsg --resource-group $ResourceGroup --location $Location
az network nsg rule create -g $ResourceGroup --nsg-name $Nsg --name $NsgRuleName --direction inbound --destination-address-prefix $DestinationAddressPrefix --destination-port-range $DestinationPortRange --access allow --priority 100

# Attach the network security group to vnet-hub-subnet1
az network vnet subnet update -g $ResourceGroup -n $SubnetName --vnet-name $VnetName --network-security-group $Nsg

# Create a VM 
VmName=vnet-hub-vm1
AdminUser=azureuser
AdminPassword=Azure123456!

az vm create --resource-group $ResourceGroup --name $VmName --image UbuntuLTS --vnet-name $VnetName --subnet $SubnetName  --admin-username $AdminUser --admin-password $AdminPassword
az network vnet subnet list -g $ResourceGroup --vnet-name $VnetName -o table
