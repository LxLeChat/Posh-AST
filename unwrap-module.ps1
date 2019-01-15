
## get AST from current file
## Module contains list of functions
## i want to create a ps1 file for each function present in the module

$Path = 'C:\temp\zou\module.psm1'
$ExportPath = "c:\temp\module\Functions\Public"
$Raw = [System.Management.Automation.Language.Parser]::ParseFile($Path, [ref]$null, [ref]$Null)

## Find All functions and in the current module file
$ListOfFunctions = $Raw.FindAll({$true}, $true) | Where-Object -FilterScript {
    If(($PSItem.GetType().Name -eq 'FunctionDefinitionAst') -and ($PSItem.Extent.text -match '^function')){
        $PSItem
    }
} | Select-Object name,@{l='Type';e={$PSItem.GetType().Name}},@{l='RawCode';e={$PSItem.extent.text}}

## Export each function code into it's own ps1 file
$ListOfFunctions.foreach({
    $PSItem.RawCode >> "$ExportPath\$($PSItem.Name).ps1"
})
