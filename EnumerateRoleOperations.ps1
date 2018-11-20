function EnumerateRoleOperations ($role)

{

    if ($role)
    {
        $role = Get-AzureRmRoleDefinition -Name $role
    }
    
    $OutputList = $null
    $OutputList = @()
    $actions = $role.Actions


    if($role)
    {

        foreach ($action in $actions ) 

        {

            $operations = Get-AzureRMProviderOperation $action | Select Operation
       

            foreach ($operation in $operations)

            {


                $ListItem =  [pscustomobject] @{

                    Operation = $operation.Operation
                    ParentOperation = $action
                }

                $OutputList +=$ListItem
                $ListItem = $null

            }

        }

        return $OutputList

    }
    else
    {
        $operations = Get-AzureRMProviderOperation | Select Operation

        foreach ($operation in $operations)

        {


            $ListItem =  [pscustomobject] @{

                Operation = $operation.Operation
                ParentOperation = $action
            }

            $OutputList +=$ListItem
            $ListItem = $null

        }

    
    return $OutputList

    }
}
