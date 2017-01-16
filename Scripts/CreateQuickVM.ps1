#Quick Create Azure VM

Clear-Host

$cloudServiceName = "seyonvm001"
#(Get-AzureLocation).DisplayName
$location = "South India"
$size = "Small"
$vmName ="seyonvm001"
#(Get-AzureVMImage).ImageFamily
$imageFamily = "Windows Server 2012 R2 Datacenter"

$imageName = Get-AzureVMImage | where {$_.ImageFamily -eq $imageFamily} | 
    sort PublishedData -Descending |
        select -ExpandProperty ImageName -First 1

$adminuser = "Kumar"
$password = "Password@123"

$storename = "seyonstore"

New-AzureStorageAccount -StorageAccountName $storename -Location $location

$subsname = (Get-AzureSubscription).SubscriptionName 
Set-AzureSubscription -SubscriptionName $subsname -CurrentStorageAccountName $storename

New-AzureQuickVM -Windows -ServiceName $cloudServiceName -Name $vmName -ImageName $imageName -AdminUsername $adminuser -Password $password -Location $location -InstanceSize $size