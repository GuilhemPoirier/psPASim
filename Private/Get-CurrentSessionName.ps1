function Get-CurrentSessionName {
    [CmdletBinding()]
    param(
        [switch]$WithQuotes
    )
    $values = Get-Variable -Name PSBAS_SESSIONS -ValueOnly | Select-Object -ExpandProperty Keys
    if ($WithQuotes)
    {
        $values | ForEach { If ( "$_" -like "* *" ) { "`"$_`"" } Else { $_ } }
    }
    else
    {
        $values
    }
}