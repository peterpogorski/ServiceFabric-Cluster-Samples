param(
    [string] [Parameter(Mandatory = $true)] $ResourceGroupName,
    # [string] [Parameter(Mandatory = $true)] $KeyVaultResourceGroupName,
    # [string] [Parameter(Mandatory = $true)] $KeyVaultName,
    [string] $KeyVaultResourceGroupName = "pepogors-keyvault",
    [string] $KeyVaultName = "pepogors-kv",
    [string] [Parameter(Mandatory = $true)] $Password,
    [string] $Template = "azuredeploy.json",
    [string] $Parameters = "azuredeploy.parameters.json", 
    [string] $Location = "westus"
)

$certpwd=$Password | ConvertTo-SecureString -AsPlainText -Force

$resourceGroup = New-AzureRmResourceGroup -Name $ResourceGroupName -Location $Location

# New-AzureRmServiceFabricCluster `
#     -ResourceGroupName $ResourceGroupName `
#     -TemplateFile "$PSScriptRoot\$Template" `
#     -ParameterFile "$PSScriptRoot\$Parameters"
#     -CertificatePassword $certpwd `
#     -KeyVaultName $KeyVaultName  `
#     -KeyVaultResouceGroupName $KeyVaultResourceGroupName  `
#     -CertificateFile "$PSScriptRoot\pepogors-keyvault.pfx"

# New-AzureRmServiceFabricCluster  `
#     -ResourceGroupName $ResourceGroupName  `
#     -TemplateFile "$PSScriptRoot\$Template" `
#     -ParameterFile "$PSScriptRoot\$Parameters" 

New-AzureRmResourceGroupDeployment `
    -ResourceGroupName $ResourceGroupName `
    -TemplateFile $Template `
    -TemplateParameterFile $Parameters