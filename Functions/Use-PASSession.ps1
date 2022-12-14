function Use-PASSession
{
    [CmdletBinding()]
    param(
        [Parameter(ParameterSetName='Session',Mandatory=$true, Position=0, ValueFromPipeline=$true)]
        [PSTypeName('psPAS.CyberArk.Vault.Session')]
        [System.Object]
        ${Session},
        
        [Parameter(ParameterSetName='withEnv', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ArgumentCompleter(
            {
                param($Command, $Parameter, $WordToComplete, $CommandAst, $FakeBoundParams)
                Get-CurrentSessionName -WithQuotes
            }
        )]
        [ValidateScript(
            {
                $_ -in (Get-CurrentSessionName)
            }
        )]
        [string]
        ${Environment})

    begin
    {
        try {
            $outBuffer = $null
            if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer))
            {
                $PSBoundParameters['OutBuffer'] = 1
            }
            $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('PsPAS\Use-PASSession', [System.Management.Automation.CommandTypes]::Function)
            if ($PSBoundParameters['Environment'])
            {
                $sessions = Get-Variable -Name PSBAS_SESSIONS -ValueOnly
                $scriptCmd = {& $wrappedCmd -Session  $sessions[$PSBoundParameters['Environment']]}
            }
            else
            {
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

    .ForwardHelpTargetName Use-PASSession
    .ForwardHelpCategory Function

    #>

}