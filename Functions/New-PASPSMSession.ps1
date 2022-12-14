function New-PASPSMSession
{
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium')]
    param(
        [Parameter(ParameterSetName='PSMConnect', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias("id")]
        [string]
        ${AccountID},

        [Parameter(ParameterSetName='AdHocConnect', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]
        ${userName},

        [Parameter(ParameterSetName='AdHocConnect', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [securestring]
        ${secret},

        [Parameter(ParameterSetName='AdHocConnect', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]
        ${address},

        [Parameter(ParameterSetName='AdHocConnect', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]
        ${platformID},

        [Parameter(ParameterSetName='AdHocConnect', ValueFromPipelineByPropertyName=$true)]
        [string]
        ${extraFields},

        [Parameter(ParameterSetName='AdHocConnect', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='PSMConnect', ValueFromPipelineByPropertyName=$true)]
        [string]
        ${reason},

        [Parameter(ParameterSetName='AdHocConnect', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='PSMConnect', ValueFromPipelineByPropertyName=$true)]
        [string]
        ${TicketingSystemName},

        [Parameter(ParameterSetName='AdHocConnect', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='PSMConnect', ValueFromPipelineByPropertyName=$true)]
        [string]
        ${TicketId},

        [Parameter(ParameterSetName='AdHocConnect', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='PSMConnect', Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]
        ${ConnectionComponent},

        [Parameter(ParameterSetName='AdHocConnect', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='PSMConnect', ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('Yes','No')]
        [string]
        ${AllowMappingLocalDrives},

        [Parameter(ParameterSetName='AdHocConnect', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='PSMConnect', ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('Yes','No')]
        [string]
        ${AllowConnectToConsole},

        [Parameter(ParameterSetName='AdHocConnect', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='PSMConnect', ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('Yes','No')]
        [string]
        ${RedirectSmartCards},

        [Parameter(ParameterSetName='AdHocConnect', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='PSMConnect', ValueFromPipelineByPropertyName=$true)]
        [string]
        ${PSMRemoteMachine},

        [Parameter(ParameterSetName='AdHocConnect', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='PSMConnect', ValueFromPipelineByPropertyName=$true)]
        [string]
        ${LogonDomain},

        [Parameter(ParameterSetName='AdHocConnect', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='PSMConnect', ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('Yes','No')]
        [string]
        ${AllowSelectHTML5},

        [Parameter(ParameterSetName='AdHocConnect', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='PSMConnect', ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('RDP','PSMGW')]
        [string]
        ${ConnectionMethod},

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [ValidateScript({  Test-Path -Path $_ -IsValid  })]
        [string]
        ${Path})

    begin
    {
        try {
            $outBuffer = $null
            if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer))
            {
                $PSBoundParameters['OutBuffer'] = 1
            }
            $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('PsPAS\New-PASPSMSession', [System.Management.Automation.CommandTypes]::Function)
            if ($PSBoundParameters['ConnectionComponent'])
            {
                $scriptCmd = {& $wrappedCmd @PSBoundParameters | % { Start-Process -FilePath "mstsc" -ArgumentList "`"$($_.FullName)`"" } }
                
            }
            else
            {
                $account = Get-PASAccount -id $PSBoundParameters['AccountID']
                $policy = Get-PASPlatform | where { $_.PlatformID -eq $account.platformId }
                $connector = Get-PASPlatformPSMConfig -ID $policy.Details.ID | select -ExpandProperty PSMConnectors | where { $_.Enabled -eq "True" } | select -ExpandProperty PSMConnectorID -First 1
                $scriptCmd = {& $wrappedCmd @PSBoundParameters -ConnectionComponent $connector | % { Start-Process -FilePath "mstsc" -ArgumentList "`"$($_.FullName)`"" } }
            }
            $steppablePipeline = $scriptCmd.GetSteppablePipeline()
            $steppablePipeline.Begin($PSCmdlet)
        } catch {
            throw
        }
    }

    process
    {
        try {
            $steppablePipeline.Process($_)
        } catch {
            throw
        }
    }

    end
    {
        try {
            $steppablePipeline.End()
        } catch {
            throw
        }
    }
    <#

    .ForwardHelpTargetName New-PASPSMSession
    .ForwardHelpCategory Function

    #>
}
