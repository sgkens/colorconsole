using module ..\keyfile\keyfile.psm1 # Import Get-KeyFromFile
#---CONFIG----------------------------

$ModuleName = Get-KeyfromFile -path '.\build\build_config.json' -key 'ModuleName'

$ModuleManifest = Test-ModuleManifest -path ".\dist\$modulename\$modulename.psd1"
#---CONFIG----------------------------


# Choco supports markdown nuget and psgallary done
$Choco_description = Get-Content -Path ..\Choco_description.md


if (!(Test-Path -path ".\dist\nuget")) { mkdir ".\dist\nuget" }
if (!(Test-Path -path ".\dist\choco")) { mkdir ".\dist\choco" }
if (!(Test-Path -path ".\dist\psgal")) { mkdir ".\dist\psgal" }


# ===========================================
#             PowerShell Gallery
# ===========================================
[console]::write( "Creating Zip File for PSGallery `n" )
[console]::write( "Source: .\dist\$($ModuleName)\* `n" )
[console]::write( "output: .\dist\psgal\$($zipFileName) `n" )
$zipFileName = "$($NuSpecParams.ModuleName).zip"
# Create Zip With .nuspec file for PSGallery
compress-archive -path ".\dist\$ModuleName\*" `
  -destinationpath ".\dist\psgal\$zipFileName" `
  -compressionlevel optimal `
  -update


# ===========================================
#                NUGET
# ===========================================
$NuSpecParams = @{
  path          = ".\dist\$ModuleName"
  ModuleName    = $ModuleName
  ModuleVersion = $ModuleManifest.Version -replace "\.\d+$", ""
  Author        = $ModuleManifest.Author
  Description   = $ModuleManifest.Description
  ProjectUrl    = $ModuleManifest.PrivateData.PSData.ProjectUrl
  License       = "MIT"
  company       = $ModuleManifest.CompanyName
  Tags          = $ModuleManifest.Tags
  dependencies  = $ModuleManifest.ExternalModuleDependencies
}
# Copy Custom Readme base on repository destination
Copy-item -Path ".\tools\readme-dist\nuget\readme.md"  `
          -Destination ".\dist\$ModuleName\readme.md" `
          -Force `
          -Verbose
# Create Nuget nuspec, Proget, gitlab, PSGallery
New-NuspecPackageFile @NuSpecParams
# Create New Verification CheckSums
New-VerificationFile -Path ".\dist\$modulename"  -OutputFile ".\dist\$modulename\tools"
Start-sleep -Seconds 2 # Wait for file to be created
New-NupkgPackage -path ".\dist\$ModuleName"  -outpath ".\dist\nuget"


# ===========================================
#                CHOCOLATEY
# ===========================================
$NuSpecParamsChoco = @{
  path              = ".\dist\$ModuleName"
  ModuleName        = $ModuleName
  ModuleVersion     = $ModuleManifest.Version -replace "\.\d+$", "" # remove the extra .0 as semver has 0.0.0 and powershell 0.0.0.0
  Author            = $ModuleManifest.Author
  Description       = $Choco_description #-replace '```', '```' -replace '\`', '``'
  Summary           = $ModuleManifest.Description
  ProjectUrl        = $ModuleManifest.PrivateData.PSData.ProjectUrl
  IconUrl           = $ModuleManifest.PrivateData.PSData.IconUrl
  docsUrl           = $ModuleManifest.PrivateData.PSData.docsUrl
  projectSourceUrl  = $ModuleManifest.PrivateData.PSData.projectSourceUrl 
  MailingListUrl    = $ModuleManifest.PrivateData.PSData.MailingListUrl
  bugTrackerUrl     = $ModuleManifest.PrivateData.PSData.BugTrackerUrl
  LicenseUrl        = $ModuleManifest.PrivateData.PSData.LicenseUrl
  ReleaseNotes      = $ModuleManifest.PrivateData.PSData.ReleaseNotes
  # License           = "MIT"
  company           = $ModuleManifest.CompanyName
  Tags              = $ModuleManifest.Tags
  dependencies      = $ModuleManifest.ExternalModuleDependencies
  LicenseAcceptance = $false
}

# Copy Custom Readme base on repository destination
Copy-item -Path ".\tools\readme-dist\choco\readme.md"  `
          -Destination ".\dist\$ModuleName\readme.md" `
          -Force `
          -Verbose

# Create Choco nuspec
New-ChocoNuspecFile @NuSpecParamsChoco
# Create New Verification CheckSums
New-VerificationFile -Path ".\dist\$modulename" -OutputFile ".\dist\$modulename\tools"
Start-sleep -Seconds 2 # Wait for file to be created
New-ChocoPackage -path ".\dist\$ModuleName"  -outpath ".\dist\choco"