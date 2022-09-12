function Get-PASAccount
{
    [CmdletBinding(DefaultParameterSetName='Gen2Query')]
    param(
        [Parameter(ParameterSetName='Gen2ID', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [Alias('AccountID')]
        [string]
        ${id},

        [Parameter(ParameterSetName='Gen2Query', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Gen2Filter', ValueFromPipelineByPropertyName=$true)]
        [string]
        ${search},

        [Parameter(ParameterSetName='Gen2Query', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Gen2Filter', ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('startswith','contains')]
        [string]
        ${searchType},

        [Parameter(ParameterSetName='Gen2Query', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Gen2ByProperty', ValueFromPipelineByPropertyName=$true)]
        [string]
        ${safeName},

        [Parameter(ParameterSetName='Gen2Query', ValueFromPipelineByPropertyName=$true)]
        [datetime]
        ${modificationTime},

        [Parameter(ParameterSetName='Gen2Query', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Gen2Filter', ValueFromPipelineByPropertyName=$true)]
        [string[]]
        ${sort},

        [Parameter(ParameterSetName='Gen2Filter', ValueFromPipelineByPropertyName=$true)]
        [string]
        ${filter},

        [Parameter(ParameterSetName='Gen1', ValueFromPipelineByPropertyName=$true)]
        [ValidateLength(0, 500)]
        [string]
        ${Keywords},

        [Parameter(ParameterSetName='Gen1', ValueFromPipelineByPropertyName=$true)]
        [ValidateLength(0, 28)]
        [string]
        ${Safe},

        [Parameter(ParameterSetName='Gen2ByProperty', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]
        ${Property},

        [Parameter(ParameterSetName='Gen2ByProperty', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]
        ${Value},

        [int]
        ${TimeoutSec})

    begin
    {
        try {
            $outBuffer = $null
            if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer))
            {
                $PSBoundParameters['OutBuffer'] = 1
            }
            $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('PsPAS\Get-PASAccount', [System.Management.Automation.CommandTypes]::Function)
            if ($PSBoundParameters['Property'])
            {
                $PSBoundParameters.Remove('Property') | Out-Null
                $PSBoundParameters.Remove('Value') | Out-Null
                if ("safe","address","username","platformid" -contains $Property.ToLower())
                {
                    $scriptCmd = {& $wrappedCmd @PSBoundParameters -search $Value | Where-Object -Filter { ($_ | Select-Object -ExpandProperty $Property) -eq $Value}}
                }
                else
                {
                    $scriptCmd = {& $wrappedCmd @PSBoundParameters -search $Value | Where-Object -Filter { ($_ | Select-Object -ExpandProperty platformAccountProperties | Select-Object -ExpandProperty $Property -ErrorAction Ignore) -eq $Value}}
                }
            }
            else {
                $scriptCmd = {& $wrappedCmd @PSBoundParameters }
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

    .ForwardHelpTargetName Get-PASAccount
    .ForwardHelpCategory Function

    #>
}
