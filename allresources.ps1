# Ensure you are logged in to Azure
 
# Get all subscriptions in the Azure account
$subscriptions = Get-AzSubscription
 
# Initialize array to store resource data
$resourceData = @()
 
# Iterate through each subscription
foreach ($subscription in $subscriptions) {
Set-AzContext -SubscriptionId $subscription.Id
 
    # Get all resources in the current subscription
    $resources = Get-AzResource
 
    foreach ($resource in $resources) {
        if ($resource.Tags) {
            foreach ($tag in $resource.Tags.GetEnumerator()) {
                $resourceData += [PSCustomObject]@{
                    SubscriptionID = $subscription.Id
                    SubscriptionName = $subscription.Name
                    ResourceID       = $resource.ResourceId
                    ResourceName = $resource.Name
                    ResourceType     = $resource.ResourceType
                    ResourceLocation = $resource.Location
                    ResourceGroup    = $resource.ResourceGroupName
                    TagName          = $tag.Key
                    TagValue         = $tag.Value
                }
            }
        } else {
            # If no tags, add resource with empty Tag Name & Value
            $resourceData += [PSCustomObject]@{
            SubscriptionID = $subscription.Id
            SubscriptionName = $subscription.Name
            ResourceID       = $resource.ResourceId
            ResourceName = $resource.Name
            ResourceType     = $resource.ResourceType
            ResourceLocation = $resource.Location
            ResourceGroup    = $resource.ResourceGroupName
            TagName          = ""
            TagValue         = ""
            }
        }
    }
}
 
# Export to CSV
$csvPath = "./reports/AzureResourceTagReport.csv"
$resourceData | Export-Csv -Path $csvPath -NoTypeInformation
 
Write-Output "Resource tag report saved to: $csvPath"
