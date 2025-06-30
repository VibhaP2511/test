# Install-Module -Name Az -AllowClobber -Force
# Import-Module -Name Az  -Force
#hello
$script:resourceData = @()
$subscriptions = Get-AzSubscription
foreach($subscription in $subscriptions)
{
    Set-AzContext -Subscription $subscription.Id
    try{   
    $allResources = Get-AzResource
    $resourceD = @()
    foreach($resource in $allResources){       
        $dataRow = [pscustomobject]@{                        
                        "Subscription Name" = $subscription.Name
                        "Resource Name" = $resource.Name
                        "Resource Group Name" = $resource.ResourceGroupName
                        "Resource Type" = $resource.ResourceType
                        "Location" = $resource.location
                        "Resource Id" = $resource.ResourceId                  
                    }
        $resourceD += $dataRow
    }
    $script:resourceData += $resourceD 
    }catch{
 
    Write-Output "Error while fetching all resources - $($error[0])"
 
   }
}
$script:resourceData | Export-Csv -Path "Azure_All_Resources.csv" -Force -NoTypeInformation -Encoding UTF8
 
 
# $fileName = "Azure_All_Resources.csv"
# $authority = "https://login.microsoftonline.com/189de737-c93a-4f5a-8b68-6f4ca9941912/oauth2/token"
# $resourceUrl = "https://communication.azure.com"

# $body = @{grant_type = "client_credentials"
#           client_id = $clientId
#           client_secret = $pass
#           resource = 'https://communication.azure.com'
# }
# $response = Invoke-WebRequest -Method Post -Uri $authority -Body $body -ContentType 'application/x-www-form-urlencoded' -UseBasicParsing
# $accessToken = $response.Content | ConvertFrom-Json
# $accessToken.access_token
# $uuid = [guid]::NewGuid().ToString()
# $gmt = get-date -format U
# $base64_csv = [Convert]::ToBase64String([IO.File]::ReadAllBytes($($fileName)))
 
# $params = @{
#     Method = 'POST'
#     URI = 'https://eops-acs.australia.communication.azure.com/emails:send?api-version=2023-03-31'
#     Headers = @{
#         Authorization = 'Bearer ' + $accessToken.access_token
#         'Content-Type' = 'application/json'
#         'repeatability-first-sent' = $gmt
#         'repeatability-request-id' = $uuid 
#     }
#     Body = @{
#         senderAddress = 'hcl-elasticops@aa34110f-dc60-463e-b5cf-bd3b7c8ce04d.azurecomm.net'
#         Content = @{
#             Subject = 'Azure | All Resources'
#             PlainText = 'used azure communication service'
#             html = "<html><head><title> !</title></head><body><p>Greetings,</p>
# <p>Please find attached Azure All Resources Report for your reference.</p>
# <p>
#                         Note that this is automatically generated email via Github Actions. For any queries or concerns, please reach out at AUTONOMICS-DEVOPS@HCL.COM</p>
# <p><br>Regards,</p>
# <p>EOPS AUTONOMICS</p>
# </body></html>"
#         }
#         recipients = @{
#             To = @(
#                 @{
#                 address = 'padam.sinha@hcltech.com'
#                 displayName = 'Padam'
#                 }

#             )
#             Cc = @(
#                @{
#                 address = 'padam.sinha@hcl.com'
#                 displayName = 'Sinha'
#                 }
#             )
#         }
#         Attachments = @(
#            @{ 
#             name = $($fileName)
#             contentType = "text/csv"
#             contentInBase64 = $($base64_csv)
#            }
#         )
#     } | ConvertTo-Json -Depth 100
# }
# (Invoke-WebRequest @params -UseBasicParsing).RawContent
