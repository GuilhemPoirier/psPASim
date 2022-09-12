function Move-PASAccount
{
    param(
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias("id")]
        [string]
        ${AccountID},

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]
        ${safeName}
    )


    BEGIN {

	}#begin

	PROCESS {
        $accountObj = Get-PASAccount -id $AccountID
        $properties = $accountObj.platformAccountProperties.psobject.properties | foreach -begin {$h=@{}} -process {$h."$($_.Name)" = $_.Value} -end {$h}
        $createdAccount = Add-PASAccount -secretType $accountObj.secretType `
            -name $accountObj.name `
            -secret ($accountObj.GetPassword().Password | ConvertTo-SecureString -AsPlainText -Force) `
            -platformAccountProperties $properties `
            -SafeName $safeName `
            -platformID $accountObj.PlatformId `
            -Address $accountObj.Address `
            -Username $accountObj.Username
        if ($?) {
            Remove-PASAccount -AccountID $AccountID
            $createdAccount
        }

    }#process
    END { }#end
}