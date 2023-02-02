# tf-S2S-Azure-vSRX
TF Resources for creating a Site-to-Site IPsec VPN between Azure tenant and vSRX

This is modeled after the MSFT guide:
https://learn.microsoft.com/en-us/azure/vpn-gateway/tutorial-site-to-site-portal


You will need to supply your own *.tfvars or terraform.tfvars or it will prompt you on plan or apply for the inputs.

```shell
workload     = "core-networking"
environment  = "test"
azure_region = "centralus"
instance     = "000"



onpremise_address_space = "<your onprem network>"


onpremise_gateway_address =  "<your onprem GW>"
ipsec_shared_key          =  "<your key>"
admin_username            =  "<your admin name>"

# Some additional variable for Tags
owner         = "<call yourself whatever you want"
source_change = "terraform"
```

The Output will give you the PIP of the VNET Gateway and the Private IP of the Linux Host to test on in Azure from your onprem network. 
