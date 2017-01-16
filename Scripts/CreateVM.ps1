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

New-AzureStorageAccount -StorageAccountName $storename -Location $location

$subsname = (Get-AzureSubscription).SubscriptionName 
Set-AzureSubscription -SubscriptionName $subsname -CurrentStorageAccountName $storename

# minimum requirement - $vm1config = New-AzureVMConfig -Name $vmName -InstanceSize $size -ImageName $imageName |

$vm1config = New-AzureVMConfig -Name $vmName -InstanceSize $size -ImageName $imageName |
    Add-AzureProvisioningConfig -Windows -AdminUsername $adminuser -Password $password |
    Add-AzureEndpoint -Name "HTTP" -Protocol tcp -PublicPort 80 -LocalPort 80 |
    Add-AzureDataDisk -CreateNew -DiskSizeInGB 20 -LUN 0 -DiskLabel "Data"

New-AzureVM -ServiceName $cloudServiceName -Location $location -VMs $vm1config