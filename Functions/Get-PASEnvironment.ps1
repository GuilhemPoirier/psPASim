function Get-PASEnvironment {

    $file = Get-Variable -Name PSBAS_JSON_FILE -ValueOnly

    if (Test-Path -Path $file -PathType Leaf) {
        $content = Get-Content -Path $file -Raw | ConvertFrom-Json
        if ($content -isnot [array]) {
            $content = ,$content
        }
        $content
    }

}