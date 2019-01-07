param(
    [string] [Parameter(Mandatory = $true)] $ResourceGroupName,
    [string] [Parameter(Mandatory = $true)] $KeyVaultName,
    [string] [Parameter(Mandatory = $true)] $Password,
    [string] $Location = "westus"
)

. "$PSScriptRoot\Cluster-Creation-Functions.ps1"

CheckLogin
CheckAndCreateResourceGroup $ResourceGroupName $Location
CheckAndCreateKeyVault $ResourceGroupName $KeyVaultName $Location
$certThumbprint, $certPath = CreateSelfSignedCertificate $ResourceGroupName $Password
$kvCert = ImportCertificateIntoKeyVault $KeyVaultName $ResourceGroupName $certPath $Password
