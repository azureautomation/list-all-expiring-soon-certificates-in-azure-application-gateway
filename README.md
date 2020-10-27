List all expiring soon certificates in Azure Application Gateway
================================================================

            
The problematic

Did you ever had developers or engineers coming to your desk in panic realizing their Azure Application Gateway' certificates expired without them knowing it in advance. Causing them downtime in their release pipeline, dev or worst, their production environment!


 

What is proposed

Be proactive instead of reactive with this little script. Using this, you can get the list the certificates in your Azure Application Gateway that are soon due to expire. You have full control over the desired time period to be considered as expiring soon.


It is build so that you can take the output and do whatever you want with it after, whenever it's convert it to JSON, CSV, XML.


 

Overview

This is an overview of the usage you can do of the script *Get-AzureAppGatewayExpiringCertificates*


2020-06-19 - Added support to output ImpactedListeners & CertificateName members.



PowerShell
Edit|Remove
powershell
Connect-AzAccount 
 
# Will list certificates if they expires 120 days from today  
$audit = .\Get-AzureAppGatewayExpiringCertificates.ps1 -ExpiresInDay 180 -Verbose

$audit

VERBOSE: Iteration #1                                                                                                                                                              
VERBOSE: Sent top=100 skip=0 skipToken=                                                                                                                                            
VERBOSE: Received results: 17
VERBOSE: 17

Name                           Value
----                           -----
SubscriptionId                 00000000-0000-0000-0000-000000000000
Thumbprint                     4956BCC058BCA4BCB1349357AB474CCDBB37C28AB
ResourceGroup                  poc-prod-common
SubscriptionName               my-company-subscription
NotAfter                       3/4/2019 4:51:03 PM
Cert                           [Subject]...
Name                           poc-prod-common-ag
CertificateName                Wildcard_domain_com
ImpactedListeners              {Internal-Https-Demo API-Https-Demo Portal-Https-Demo … }


# or if you want the information in JSON you can do: 
$audit | ConvertTo-Json 

Connect-AzAccount  
  
# Will list certificates if they expires 120 days from today   
$audit = .\Get-AzureAppGatewayExpiringCertificates.ps1 -ExpiresInDay 180 -Verbose 
 
$audit 
 
VERBOSE: Iteration #1                                                                                                                                                               
VERBOSE: Sent top=100 skip=0 skipToken=                                                                                                                                             
VERBOSE: Received results: 17 
VERBOSE: 17 
 
Name                           Value 
----                           ----- 
SubscriptionId                 00000000-0000-0000-0000-000000000000 
Thumbprint                     4956BCC058BCA4BCB1349357AB474CCDBB37C28AB 
ResourceGroup                  poc-prod-common 
SubscriptionName               my-company-subscription 
NotAfter                       3/4/2019 4:51:03 PM 
Cert                           [Subject]... 
Name                           poc-prod-common-ag 
CertificateName                Wildcard_domain_com 
ImpactedListeners              {Internal-Https-Demo API-Https-Demo Portal-Https-Demo … } 
 
 
# or if you want the information in JSON you can do:  
$audit | ConvertTo-Json 




 

Requirements

Tested with Azure PowerShell Az v1.x.x


Tested with Azure PowerShell Az.ResourceGraph module v0.7.6


        
    
TechNet gallery is retiring! This script was migrated from TechNet script center to GitHub by Microsoft Azure Automation product group. All the Script Center fields like Rating, RatingCount and DownloadCount have been carried over to Github as-is for the migrated scripts only. Note : The Script Center fields will not be applicable for the new repositories created in Github & hence those fields will not show up for new Github repositories.
