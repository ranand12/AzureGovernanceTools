$role1name = "ENTER ROLE1 NAME"
$role2name = "ENTER ROLE2 NAME" #LEAVE BLANK FOR ALL AZURE OPERATIONS ""



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


$role1operations =  EnumerateRoleOperations -role $role1name
$role2operations =  EnumerateRoleOperations -Role  $role2name 


$uniqueRole1 = $role1operations.operation | Sort-Object | Get-Unique -AsString
$uniqueRole2 = $role2operations.operation | Sort-Object | Get-Unique -AsString

Compare-Object -ReferenceObject $uniqueRole2 -DifferenceObject $uniqueRole1 -IncludeEqual
