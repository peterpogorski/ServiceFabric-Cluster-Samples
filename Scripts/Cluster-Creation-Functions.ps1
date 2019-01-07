$ErrorActionPreference = 'Stop'

$t = [Reflection.Assembly]::LoadWithPartialName("System.Web")

function CheckLogin() {
    $rmContext = Get-AzureRmContext

    if($rmContext.Account -eq $null) {
        Write-Host "You are not currently logged into Azure. Please login using Login-AzureRmAccount and set the subscription you would like to use Set-AzureRmContext -SubscriptionId"
        exit
    }
}

## Check if a resource group with a given name exists. If the resource group is not found, a new resource group will be created
function CheckAndCreateResourceGroup([string]$ResourceGroupName, [string]$Location) {
    $resourceGroup = Get-AzureRmResourceGroup -Name $ResourceGroupName -Location $Location -ErrorAction Ignore
    if($resourceGroup -eq $null)
    {
        Write-Host "Creating a new resource group..."
        $resourceGroup = New-AzureRmResourceGroup -Name $ResourceGroupName -Location $Location
        Write-Host "New resource group created."
    }
}

function CheckAndCreateKeyVault([string]$ResourceGroupName, [string]$KeyVaultName, [string]$Location) {
    $keyVault = Get-AzureRmKeyVault -VaultName $KeyVaultName -ErrorAction Ignore
    if($keyVault -eq $null)
    {
        Write-Host "Creating a new Key Vault..."
        $keyVault = New-AzureRmKeyVault -VaultName $KeyVaultName -ResourceGroupName $ResourceGroupName -Location $Location -EnabledForDeployment
        Write-Host "Key Vault Created."
        Write-Host $keyVault.ResourceId
    }
}

function CreateSelfSignedCertificate([string]$DnsName, [string]$Password) {
    Write-Host "Creating self-signed certificate with dns name $DnsName"
    
    $filePath = "$PSScriptRoot\$DnsName.pfx"

    Write-Host "  generating certificate... " -NoNewline
    $securePassword = ConvertTo-SecureString $Password -AsPlainText -Force
    $thumbprint = (New-SelfSignedCertificate -DnsName $DnsName -CertStoreLocation Cert:\CurrentUser\My -KeySpec KeyExchange).Thumbprint
    Write-Host "$thumbprint."
    
    Write-Host "  exporting to $filePath..."
    $certContent = (Get-ChildItem -Path cert:\CurrentUser\My\$thumbprint)
    $t = Export-PfxCertificate -Cert $certContent -FilePath $filePath -Password $securePassword
    Write-Host "  exported."

    $thumbprint
    $filePath
}

function ImportCertificateIntoKeyVault([string]$KeyVaultName, [string]$CertName, [string]$CertFilePath, [string]$CertPassword)
{
    #Write-Host
    Write-Host "Importing certificate..."
    Write-Host "  generating secure password..."
    $securePassword = ConvertTo-SecureString $CertPassword -AsPlainText -Force
    Write-Host "  uploading to KeyVault..."
    Import-AzureKeyVaultCertificate -VaultName $KeyVaultName -Name $CertName -FilePath $CertFilePath -Password $securePassword
    Write-Host "  imported."
}