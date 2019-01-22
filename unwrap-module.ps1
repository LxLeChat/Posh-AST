## Create a ps1 file for each function present in the module file

## Module must contains list of functions, otherwise it's pointless...
$Path = 'C:\temp\zou\module.psm1'

## Export Path
$ExportPath = "c:\temp\module\Functions\Public"

## get AST from current file
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


################################
##https://plus.google.com/events/co64vc41tkaivdpdihppt20trig
## Module must contains list of functions, otherwise it's pointless...
$Path = 'C:\temp\zou\module.psm1'

## Export Path
$ExportPath = "c:\temp\module\Functions\Public"

## get AST from current file
$Raw = [System.Management.Automation.Language.Parser]::ParseFile($Path2, [ref]$null, [ref]$Null)
## parse for functions, only functions ... not classes
$raw.FindAll({$args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst]}$False) | ForEach-Object -Process {If ( $_.Extent.Text -match '^function' ) { $_}} | select name
