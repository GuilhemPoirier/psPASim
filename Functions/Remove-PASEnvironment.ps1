function Remove-PASEnvironment {
    param (
        [parameter(
			Mandatory = $true,
			ValueFromPipeline = $true,
			ValueFromPipelinebyPropertyName = $true
		)]
        [ArgumentCompleter(
            {
                param($Command, $Parameter, $WordToComplete, $CommandAst, $FakeBoundParams)
                Get-ValidEnvironmentName -WithQuotes
            }
        )]
        [ValidateScript(
            {
                $_ -in (Get-ValidEnvironmentName)
            }
        )]
        [string]$Name
    )
    $file = Get-Variable -Name PSBAS_JSON_FILE -ValueOnly
    if (Test-Path -Path $file -PathType Leaf) {
        $content = Get-Content -Path $file -Raw | ConvertFrom-Json
        $content | Where-Object { $_.Name –ne $Name } | ConvertTo-Json | Out-File $file
    }
}