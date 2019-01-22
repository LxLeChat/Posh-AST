## checker les comments:
## https://www.powershellgallery.com/packages/ISEScriptingGeek/3.3.1.2/Content/Get-ScriptComments.ps1
## il faut ajouter 2 param au parsefile une variable créé avec new-variable genre:
## new-variable test ::ParseFile($file.FullName, [ref]$test, [ref]$Null)
## du coup ça donne une variable contenant des ... tokens
## créé une section help pour chaque fonction
## ajoute les parametres!

$path = 'C:\temp\zou\Functions\Public'

Foreach ( $file in (gci -path $path -filter '*.ps1') ){
    $file.FullName
    $Raw = [System.Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref]$null, [ref]$Null)
    $params = $raw.FindAll({$args[0] -is [System.Management.Automation.Language.ParamBlockAst]},$False)

$textToAdd = @"
<#
    .SYNOPSIS
        Short description
    .DESCRIPTION
        Long description
    .EXAMPLE
        PS C:\> <example usage>
        Explanation of what the example does
{0}
    .NOTES
        General notes
    #>
"@

$zou = ""

Foreach($param in $params.Parameters){
    If($zou -eq "" ) {
        $zou +=@"
`t.PARAMETER {0}
`t`t{0} Must be of type {1}
"@ -f  ($param.name.Extent.Text).Replace('$',''), $param.Attributes.Extent.Text
    } else {
        $zou +=@"
`n`t.PARAMETER {0}
`t`t{0} Must be of type {1}
"@ -f  ($param.name.Extent.Text).Replace('$',''), $param.Attributes.Extent.Text
    }
}

    $x=$textToAdd -f $zou
    $i=0
    $NewContent=Get-Content -path $file.FullName | ForEach-Object{
        if ($i -eq 0){
            $_ + "`n`t" + $x
            $i++
        } else {
            $_
        }
    }

    Set-Content -Value $NewContent -Path $file.FullName -Force
}

