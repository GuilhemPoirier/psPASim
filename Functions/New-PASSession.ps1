function New-PASSession
{
    [CmdletBinding(DefaultParameterSetName='Gen2', SupportsShouldProcess=$true, ConfirmImpact='Medium')]
    param(
        [Parameter(ParameterSetName='Gen1Radius', Mandatory=$true, ValueFromPipeline=$true)]
        [Parameter(ParameterSetName='Gen1', Mandatory=$true, ValueFromPipeline=$true)]
        [Parameter(ParameterSetName='Gen2Radius', Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Gen2', Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [pscredential]
        [System.Management.Automation.CredentialAttribute()]
        ${Credential},

        [Parameter(ParameterSetName='Gen1SAML', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Gen1Radius', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Gen1', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [Alias('UseClassicAPI')]
        [switch]
        ${UseGen1API},

        [Parameter(ParameterSetName='Gen1', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Gen2', ValueFromPipelineByPropertyName=$true)]
        [securestring]
        ${newPassword},

        [Parameter(ParameterSetName='Gen2SAML', ValueFromPipelineByPropertyName=$true)]
        [switch]
        ${SAMLAuth},

        [Parameter(ParameterSetName='Gen1SAML', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Gen2SAML', ValueFromPipelineByPropertyName=$true)]
        [Alias('SAMLToken')]
        [string]
        ${SAMLResponse},

        [Parameter(ParameterSetName='shared', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [switch]
        ${UseSharedAuthentication},

        [Parameter(ParameterSetName='Gen1Radius', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [bool]
        ${useRadiusAuthentication},

        [Parameter(ParameterSetName='Gen2Radius', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Gen2', ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('CyberArk','LDAP','Windows','RADIUS')]
        [string]
        ${type},

        [Parameter(ParameterSetName='Gen1Radius', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Gen2Radius', ValueFromPipelineByPropertyName=$true)]
        [string]
        ${OTP},

        [Parameter(ParameterSetName='Gen1Radius', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Gen2Radius', ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('Append','Challenge')]
        [string]
        ${OTPMode},

        [Parameter(ParameterSetName='Gen1Radius', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Gen2Radius', ValueFromPipelineByPropertyName=$true)]
        [ValidateLength(1, 1)]
        [string]
        ${OTPDelimiter},

        [Parameter(ParameterSetName='Gen1Radius', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Gen2Radius', ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('Password','OTP')]
        [string]
        ${RadiusChallenge},

        [Parameter(ParameterSetName='integrated', ValueFromPipelineByPropertyName=$true)]
        [switch]
        ${UseDefaultCredentials},

        [Parameter(ParameterSetName='Gen2SAML', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='integrated', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Gen2Radius', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Gen2', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='withEnv', ValueFromPipelineByPropertyName=$true)]
        [bool]
        ${concurrentSession},

        [Parameter(ParameterSetName='Gen1Radius', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Gen1', ValueFromPipelineByPropertyName=$true)]
        [ValidateRange(1, 100)]
        [int]
        ${connectionNumber},

        [Parameter(ParameterSetName='Gen1Radius', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Gen1', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Gen2Radius', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Gen2', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Gen1SAML', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Gen2SAML', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='integrated', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='shared', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]
        ${BaseURI},

        [Parameter(ParameterSetName='Gen1Radius', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Gen1', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Gen2Radius', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Gen2', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Gen1SAML', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Gen2SAML', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='integrated', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='shared',  ValueFromPipelineByPropertyName=$true)]
        [string]
        ${PVWAAppName},

        [Parameter(ParameterSetName='Gen1Radius')]
        [Parameter(ParameterSetName='Gen1')]
        [Parameter(ParameterSetName='Gen2Radius')]
        [Parameter(ParameterSetName='Gen2')]
        [Parameter(ParameterSetName='Gen1SAML')]
        [Parameter(ParameterSetName='Gen2SAML')]
        [Parameter(ParameterSetName='integrated')]
        [Parameter(ParameterSetName='shared')]
        [switch]
        ${SkipVersionCheck},

        [Parameter(ParameterSetName='Gen1Radius')]
        [Parameter(ParameterSetName='Gen1')]
        [Parameter(ParameterSetName='Gen2Radius')]
        [Parameter(ParameterSetName='Gen2')]
        [Parameter(ParameterSetName='Gen1SAML')]
        [Parameter(ParameterSetName='Gen2SAML')]
        [Parameter(ParameterSetName='integrated')]
        [Parameter(ParameterSetName='shared')]
        [X509Certificate]
        ${Certificate},

        [Parameter(ParameterSetName='Gen1Radius')]
        [Parameter(ParameterSetName='Gen1')]
        [Parameter(ParameterSetName='Gen2Radius')]
        [Parameter(ParameterSetName='Gen2')]
        [Parameter(ParameterSetName='Gen1SAML')]
        [Parameter(ParameterSetName='Gen2SAML')]
        [Parameter(ParameterSetName='integrated')]
        [Parameter(ParameterSetName='shared')]
        [string]
        ${CertificateThumbprint},

        [Parameter(ParameterSetName='Gen1Radius', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Gen1', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Gen2Radius', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Gen2', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Gen1SAML', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='Gen2SAML', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='integrated', ValueFromPipelineByPropertyName=$true)]
        [Parameter(ParameterSetName='shared', ValueFromPipelineByPropertyName=$true)]
        [switch]
        ${SkipCertificateCheck},

        [Parameter(ParameterSetName='withEnv', ValueFromPipelineByPropertyName=$true)]
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
            $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('PsPAS\New-PASSession', [System.Management.Automation.CommandTypes]::Function)
            if ($PSBoundParameters['Environment'])
            {
                $file = Get-Variable -Name PSBAS_JSON_FILE -ValueOnly
                $parameters = (Get-Content -Path $file -Raw | ConvertFrom-Json) | Where-Object { $_.Name -eq $PSBoundParameters['Environment']}
                $cred = Get-Credential -Message "Enter Credential for Environment $($parameters.Name)" -UserName $parameters.DefaultUserName
                $PSBoundParameters.Remove('Environment') | Out-Null
                $scriptCmd = {& $wrappedCmd -BaseURI $parameters.BaseURI -Type $parameters.Type -Credential $cred @PSBoundParameters}
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
            if ($PSBoundParameters['Environment'])
            {
                $sessions = Get-Variable -Name PSBAS_SESSIONS -ValueOnly
                $sessions[$PSBoundParameters['Environment']] = Get-PASSession
            }
        } catch {
            throw
        }
    }
    <#

    .ForwardHelpTargetName New-PASSession
    .ForwardHelpCategory Function

    #>
}
