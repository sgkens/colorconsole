using module ..\keyfile\keyfile.psm1 # Import Get-KeyFromFile
#---CONFIG----------------------------
$modulename = Get-KeyfromFile -path '.\build\build_config.json' -key 'ModuleName'
#---CONFIG----------------------------

Invoke-ScriptAnalyzer -Path .\dist\$modulename `
                      -Recurse `
                      -severity warning `
                      -excluderule PSUseBOMForUnicodeEncodedFile || exit 1

# , PSAvoidUsingWriteHost 