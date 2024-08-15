using module ..\keyfile\keyfile.psm1 # Import Get-KeyFromFile
#---CONFIG----------------------------

# ModuleName
$moduleName = Get-KeyfromFile -path '.\build\build_config.json' -key 'ModuleName'
# Include
$Files       = Get-KeyfromFile -path '.\build\build_config.json' -key 'ModuleFiles'
$folders     = Get-KeyfromFile -path '.\build\build_config.json' -key 'ModuleFolders'
$exclude     = Get-KeyfromFile -path '.\build\build_config.json' -key 'ModuleExcludes'

#---CONFIG----------------------------

$AutoVersion = (Get-GitAutoVersion).Version

Build-Module -SourcePath .\ `
             -DestinationPath .\dist `
             -Name $moduleName  `
             -IncrementVersion None `
             -FilesToCopy $Files `
             -ExcludedFiles $exclude `
             -FoldersToCopy $folders `
             -Manifest `
             -Version $AutoVersion

if(!(Test-Path -Path .\dist\$moduleName\tools)) { mkdir .\dist\$moduleName\tools }