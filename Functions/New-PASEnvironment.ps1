function New-PASEnvironment {
    param (
        [parameter(
			Mandatory = $true,
			ValueFromPipeline = $true,
			ValueFromPipelinebyPropertyName = $true
		)]
        [string]$Name,

        [parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelinebyPropertyName = $true
		)]
		[string]$BaseURI,

        [Parameter(
			Mandatory = $false,
			ValueFromPipeline = $false,
			ValueFromPipelinebyPropertyName = $true
		)]
		[ValidateSet('CyberArk', 'LDAP', 'Windows', 'RADIUS')]
		[string]$type = 'CyberArk',

        [parameter(
			Mandatory = $true,
			ValueFromPipeline = $false,
			ValueFromPipelinebyPropertyName = $true
		)]
        [Alias('UserName')]
        [string]$DefaultUserName
    )

    $file = Get-Variable -Name PSBAS_JSON_FILE -ValueOnly

    if (Test-Path -Path $file -PathType Leaf) {
        $content = Get-Content -Path $file -Raw | ConvertFrom-Json
        if ($content -isnot [array]) {
            $content = ,$content
        }
    }
    else {
        $content = @()
    }

    $entry = "" | Select Name,BaseURI,Type,DefaultUserName
    $entry.Name = $Name
    $entry.BaseURI = $BaseURI
    $entry.Type = $type
    $entry.DefaultUserName = $DefaultUserName

    $content += $entry

    $content | ConvertTo-Json | Out-File $file
}