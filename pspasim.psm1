Set-Variable -Name PSBAS_JSON_FILE -value "$env:LOCALAPPDATA\psbas.json" -Scope script -Option ReadOnly
Set-Variable -Name PSBAS_SESSIONS -value @{} -Scope script

#Get function files
Get-ChildItem $PSScriptRoot\ -Recurse -Include "*.ps1" -Exclude "*.ps1xml" |

    ForEach-Object {
        if ($DotSourceModule) {
            . $_.FullName
        } else {
            $ExecutionContext.InvokeCommand.InvokeScript(
                $false,
                (
                    [scriptblock]::Create(
                        [io.file]::ReadAllText(
                            $_.FullName,
                            [Text.Encoding]::UTF8
                        )
                    )
                ),
                $null,
                $null
            )

        }

    }