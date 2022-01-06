[CmdletBinding()]
param(
    $ExpiresInDays = 90
)

$pageSize = 100
$iteration = 0
$searchParams = @{
    Query = 'resources
    | where type =~ "Microsoft.Network/applicationGateways"
    | extend ssl = parse_json(properties.sslCertificates)
    | join kind=inner (
        resourcecontainers
        | where type == "microsoft.resources/subscriptions"
        | project subscriptionId, subscriptionName = name)
        on subscriptionId
    | project name, subscriptionId, subscriptionName, resourceGroup, ssl
    | order by name'
    First = $pageSize
}

$results = do {
    $iteration += 1
    Write-Verbose "Iteration #$iteration"
    $pageResults = Search-AzGraph @searchParams
    $searchParams.Skip += $pageResults.Count
    $pageResults
    Write-Verbose $pageResults.Count
} while ($pageResults.Count -eq $pageSize)

$90daysfromNow = (Get-Date).AddDays($ExpiresInDays)
$results | foreach-object {
    $record = $_

    $record.ssl | foreach-object {
        $sslCertRecord = $_
        $cert = [System.Security.Cryptography.X509Certificates.X509Certificate2]([System.Convert]::FromBase64String($_.properties.publicCertData.Substring(60,$_.properties.publicCertData.Length-60)))
        if ($cert.NotAfter -le $90daysfromNow) {
            [pscustomobject]@{
                SubscriptionId = $record.subscriptionId
                SubscriptionName = $record.subscriptionName
                ResourceGroup = $record.resourceGroup
                Name = $record.Name
                Cert = $cert
                CertificateName = $sslCertRecord.name
                NotAfter = $cert.NotAfter
                Thumbprint = $cert.Thumbprint
                ImpactedListeners = ,@($sslCertRecord.properties.httpListeners | ForEach-Object { ($_.id -split'/')[-1] } )
            }
        }
    }
}
