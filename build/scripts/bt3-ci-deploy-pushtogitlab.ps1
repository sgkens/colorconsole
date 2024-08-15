#---CONFIG----------------------------

$ModuleName                 = Get-KeyfromFile -path '.\build\build_config.json' -key 'ModuleName'
$gitlab_username            = Get-KeyfromFile -path '.\build\build_config.json' -key 'GitUser'
$gitlab_uri                 = "https://$($ENV:GITLAB_HOST)"
$projectid                  = Get-KeyfromFile -path '.\build\build_config.json' -key 'GitlabID'

#---CONFIG----------------------------

#------------------------------------
$ModuleManifest   = Test-ModuleManifest -path ".\dist\$ModuleName\$ModuleName.psd1"
$SemVerVersion    = $ModuleManifest.Version -replace "\.\d+$", ""
$NugetProjectPath = "api/v4/projects/$projectid/packages/nuget/index.json"

try {
  Write-host -foregroundcolor yellow "Attempting to Register Gitlab: $gitlab_uri@$Gitlab_Username"
  dotnet nuget add source $gitlab_uri/$NugetProjectPath --name gitlab --username $GitLab_Username --password $ENV:GITLAB_API_KEY
  Write-host -foregroundcolor green "Complete"
}
catch [system.exception] {
  Write-Host "Failed to push to gitlab"
  Write-Host $_
}

try {
  Write-host -foregroundcolor yellow "Attempting to push $modulename to Gitlab: $gitlab_uri"
  dotnet nuget push .\dist\nuget\$modulename.$SemVerVersion.nupkg --source gitlab
}
catch [system.exception] {
  Write-Host "Failed to push to gitlab"
  Write-Host $_
}