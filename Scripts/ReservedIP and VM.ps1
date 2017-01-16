Write-Host "Starting ..." -ForegroundColor Green

# Set variables
# The values to these variables should reflect your environment or this script
# may fail to run.
# Use at your own risk

# Storage Account
$storename = "seyonvmstorage"

# cloud service name
$cloudsvcname = "seyonvms"

# Azure location
$location = 'South India'

# Name of VM
$vmname = "seyonvm100"
$vmsize="Medium"

# Admin credentials for connecting to the VM
$adminusr = "Kumar"
$pwd = "Password123!"

$reservedipname = "MyReservedIP"

$subsname = Get-AzureSubscription | select subscriptionname | ft -HideTableHeaders | Out-String
$subsname = $subsname. Trim()


Write-Host "Get Azure Subscription: ..." -ForegroundColor Yellow -NoNewline

$subsname = Get-AzureSubscription | select subscriptionname | ft -HideTableHeaders | Out-String
$subsname = $subsname. Trim()
Write-Host $subsname -NoNewline
Write-Host " Done." -ForegroundColor Green

Write-Host "Creating storage account: $storename ... " -ForegroundColor Yellow -NoNewline

New-AzureStorageAccount -StorageAccountName $storename -Location $location
Write-Host "Done." -ForegroundColor Green


Write-Host "Associating storage account to the subscription: ... " -nonewline -ForegroundColor Yellow

Set-AzureSubscription -SubscriptionName $subsname -CurrentStorageAccountName $storename
Write-Host "Done" -ForegroundColor Green



Write-Host "Wait while storage is being provisioned ..." -ForegroundColor Yellow -NoNewline
Start-Sleep -Seconds 60
Write-Host "Done." -ForegroundColor Green


Write-Host "Creating a reserved VIP ..." -ForegroundColor Yellow -NoNewline
New-AzureReservedIP –ReservedIPName $reservedipname –Label “ReservedLabel” –Location $location
Write-Host "Done." -ForegroundColor Green



Write-Host "Creating new VM: $vmname ..." -ForegroundColor Green

$img = (Get-AzureVMImage | where {$_. imagefamily -eq "Windows Server 2012 R2 Datacenter"} |
            sort PublishedDate -Descending | Select -first 1). imagename | Out-String
$img = $img. Trim()
Write-Host "Using Image: $img ..." -ForegroundColor Yellow


$newVM = New-AzureVMConfig -name $vmname -InstanceSize $vmsize -ImageName $img |
            Add-AzureProvisioningConfig -Windows -AdminUsername $adminusr -Password $pwd |
                Set-AzureVMBGInfoExtension -ReferenceName 'BGInfo'


New-AzureVM -ServiceName $cloudsvcname -Location $location -VMs $newVM -ReservedIPName $reservedipname -WaitForBoot

Write-Host "...DONE" -ForegroundColor Green 