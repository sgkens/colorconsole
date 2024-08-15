<# ---CONFIG--------------------------- #>

$ModuleName           = Get-KeyfromFile -path '.\build\build_config.json' -key 'ModuleName'
$ProGet_chocInstance  = "https://$($ENV:PROGET_HOST)/nuget/Choco"
$ProGet_nugetInstace  = "https://$($ENV:PROGET_HOST)/nuget/nuget"
$ProGet_PSGalInstance = Get-KeyfromFile -path '.\build\build_config.json' -key 'GitGroup'

<# ---CONFIG--------------------------- #>






#------------------------------------
# Output FileNames
$ModuleManifest       = Test-ModuleManifest -path ".\dist\$ModuleName\$ModuleName`.psd1"
$zipFileName          = "$($ModuleName).zip"
$SemVerVersion        = $ModuleManifest.Version -replace "\.\d+$",""
$nupkgFileName        = "$($ModuleManifest.CompanyName).$ModuleName.$SemVerVersion.nupkg"

# Force Tls12
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

if($ModuleManifest){

  # Push to ProGet Chocolatey
  if(Get-command choco){
    write-host "Checking if Chocolatey is installed, skipping install"
    write-host "Pushing to chocolatey: .\dist\choco\$nupkgFileName"
    choco push ".\dist\choco\$nupkgFileName" --source $ProGet_chocInstance --apikey $ENV:PROGET_API_KEY
    write-host "Pushed to chocolatey $nupkgFileName - Complete"
  }
  else{
    write-host "Chocolatey is not installed, installing Chocolatey"
    break;
  }

  # Push to ProGet Nuget
  if(Get-command nuget.exe){
    write-host "Checking if Nuget is installed, skipping install"
    write-host "Pushing to Nuget: .\dist\nuget\$nupkgFileName"
    nuget push ".\dist\nuget\$nupkgFileName" -source $ProGet_nugetInstace -apikey $ENV:PROGET_API_KEY
    write-host "Pushed to Nuget $nupkgFileName - Complete"
  }
  else{
    write-host "Nuget is not installed, installing Nuget"
    break;
  }
  

  # puish to proget pscore repo 'powershell gallery'
  # Publish-Module -Path ".\dist\$zipFileName" -Repository pscore -NuGetApiKey $apikey
  # Example of trusting the certificate (not recommended for production)
  # [System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }
  # Register-PSRepository -name 'pscore_Local_instance' `
  #                       -SourceLocation "https://proget.lab.davilion.online/nuget/pscore/" `
  #                       -PublishLocation (New-Object -TypeName Uri -ArgumentList "https://proget.lab.davilion.online/nuget/pscore/", 'package/').AbsoluteUri `
  #                       -InstallationPolicy "Trusted"
  

  # # Push to ProGet PSGallery
  write-host "Pushing to Powershell-Nuget-Proget: .\dist\psgal\$zipFileName"
  publish-Module `
    -path ".\dist\$ModuleName" `
    -Repository $ProGet_PSGalInstance `
    -NuGetApiKey $ENV:PROGET_API_KEY `
    -projecturi $ModuleManifest.PrivateData.PSData.ProjectUrl `
    -licenseuri $ModuleManifest.PrivateData.PSData.LicenseUrl `
    -IconUri "$(Get-KeyfromFile -path '.\keyfile.key' -key 'iconUri')"`
    -ReleaseNotes $ModuleManifest.ReleaseNotes `
    -Tags $ModuleManifest.Tags `
    -Verbose
}



