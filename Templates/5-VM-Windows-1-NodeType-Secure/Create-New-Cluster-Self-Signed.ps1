param(
    [string] [Parameter(Mandatory = $true)] $ResourceGroupName,
    [string] [Parameter(Mandatory = $true)] $KeyVaultName,
    [string] [Parameter(Mandatory = $true)] $Password,
    [string] $Template = "azuredeploy.json",
    [string] $Parameters = "azuredeploy.parameters.json", 
    [string] $Location = "westus"
)

$certpwd=$Password | ConvertTo-SecureString -AsPlainText -Force

New-AzureRmServiceFabricCluster `
    -ResourceGroupName $ResourceGroupName `
    -TemplateFile "$PSScriptRoot\$Template" `
    -ParameterFile "$PSScriptRoot\$Parameters"
    -CertificatePassword $certpwd `
    -KeyVaultName $KeyVaultName  `
    -KeyVaultResouceGroupName $ResourceGroupName  `
    -CertificateFile "$PSScriptRoot\pepogors.pfx"