#---CONFIG----------------------------

$modulename = Get-KeyfromFile -path '.\build\build_config.json' -key 'ModuleName'
$ModuleManifest = Test-ModuleManifest -path ".\dist\$ModuleName\$ModuleName`.psd1"

#---CONFIG----------------------------

#------------------------------------
publish-Module `
  -path ".\dist\$modulename" `
  -Repository 'psgallery' `
  -NuGetApiKey $ENV:PSGAL_API_KEY `
  -projecturi $ModuleManifest.ProjectUri `
  -licenseuri $ModuleManifest.LicenseUri `
  -IconUri 'https://gitlab.snowlab.tk/sgkens/resources/-/blob/raw/modules/CommitFusion/dist/v1/ccommits-logo_GitIcon_51.20dpi.png' `
  -ReleaseNotes $ModuleManifest.ReleaseNotes `
  -Tags $ModuleManifest.Tags `
  -Verbose