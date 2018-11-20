$filepath = "ENTER CSV PATH HERE"
$subscription = Get-AzureRmSubscription
$global:List = @()
foreach ($sub in $subscription)
{

    Select-AzureRmSubscription -Subscription $sub

    $rgs = Get-AzureRmResourceGroup 


        foreach ($rg in $rgs) 
        {
            
            
            $resources = (Get-AzureRmResource -ResourceGroupName $rg.ResourceGroupName)
            
            foreach ($resource in $resources)
            {
           
            $Item =  [pscustomobject] @{

            ResourceGroupName = $resource.ResourceGroupName
            ResourceType = $resource.ResourceType
            Subscription = $sub.Name
          

            }
           
           $global:List +=$Item
           $Item = $null
           }
        }
        
        
}

$global:List | Export-Csv $filepath
