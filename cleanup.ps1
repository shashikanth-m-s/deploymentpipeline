# Define the resource group names you want to remove delete locks from 
# Loop through each resource group
# Get all locks for the resource group 
# Loop through each lock and remove it
 
$resourceGroups = @("az105", "az106")
 
foreach ($resourceGroup in $resourceGroups) {
 
$locks = Get-AzResourceLock -ResourceGroupName $resourceGroup
 
foreach ($lock in $locks) { Remove-AzResourceLock -LockId $lock.LockId -Force } } 
Write-Host "Removed the locks on specific RGs."
 
#Step-2: Clean up
 
$resourceGroups = Get-AzResourceGroup
 
# Function to delete all but the latest N deployments
function Delete-OldDeployments {
  param (
    [Parameter(Mandatory=$true)]
    [string] $ResourceGroupName,
    [int] $KeepCount = 100
  )
 
  # Get deployments for the resource group
  $deployments = Get-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName
 
  # Skip the latest $KeepCount deployments
  $deploymentsToDelete = $deployments | Select-Object -Skip $KeepCount
 
  # Delete deployments (if any)
  if ($deploymentsToDelete) {
    Write-Output "Deleting old deployments in resource group: $($ResourceGroupName)"
    $deploymentsToDelete | Remove-AzResourceGroupDeployment 
  } else {
    Write-Output "No deployments to delete in resource group: $($ResourceGroupName)"
  }
}
 
# Loop through each resource group and delete old deployments
foreach ($resourceGroup in $resourceGroups) {
  Delete-OldDeployments -ResourceGroupName $resourceGroup.ResourceGroupName
}
 
 
#Step-3: Enable lock
 
 
# Define the resource group names you want to apply delete locks to
# Loop through each resource group 
# Apply the delete lock to the resource group
 
 
$resourceGroups = @("az105", "az106")
 
foreach ($resourceGroup in $resourceGroups) {
 
Set-AzResourceLock -LockName "canNotDelete" -ResourceGroupName $resourceGroup -LockLevel CanNotDelete -Force }
 
Write-Host "Enabled  the locks on specific RGs."
