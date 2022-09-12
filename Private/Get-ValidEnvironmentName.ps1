function Get-ValidEnvironmentName {
    [CmdletBinding()]
    param(
        [switch]$WithQuotes
    )
    $file = Get-Variable -Name PSBAS_JSON_FILE -ValueOnly
    $values = (Get-Content -Path $file -Raw | ConvertFrom-Json).Name
    if ($WithQuotes)
    {
        $values | ForEach { If ( "$_" -like "* *" ) { "`"$_`"" } Else { $_ } }
    }
    else
    {
        $values
    }
}