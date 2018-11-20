$filepath = <ENTER CSV PATH HERE>
$subscription = Get-AzureRmSubscription
$global:List = @()
$today = (get-date)
foreach ($sub in $subscription)
{

    Select-AzureRmSubscription -Subscription $sub

    $rgs = Get-AzureRmResourceGroup 

        foreach ($rg in $rgs) 
        {
            
            
            $activityLog = (Get-AzureRmLog -ResourceGroupName $rg.ResourceGroupName -StartTime $today.AddMonths(-2) -EndTime $today | ?{$_.caller -like "*@*"} )
            
            foreach ($activity in $activityLog)
            {
              $action = $activity.Authorization.Action
              $date = $activity.EventTimeStamp.Date.ToString("MM-dd-yyyy")
              $Item =  [pscustomobject] @{

              ResourceGroupName = $rg.ResourceGroupName
              Actions = $action
              ResourceProvider = $Action.Split('/')[0]
              Date = $date
              Subscription = $sub.Name

            }
           
           $global:List +=$Item
           $Item = $null
           }
        }
        
        
}

$global:List | Export-Csv $filepath

