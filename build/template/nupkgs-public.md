# Release Notes !NOTE have git log 
 - Notes 
 - Notes

# Package Repositories

Install the Module from the Powershell Gallary `nuget` repository

<a href="https://www.powershellgallery.com/packages/$reponame"><img src="https://img.shields.io/powershellgallery/v/$reponame?style=for-the-badge&logo=powershell&label=powershell gallery&logoColor=rgba(75%2C0%2C130%2C1)&labelColor=rgba(138%2C43%2C226%2C1)&color=rgba(106%2C90%2C205%2C1)"/></a>

```powershell 
Find-Module -Name $reponame -MinimumVersion $version | Install-module | Import-Module
```

Install the Module from the Chocolatey `nuget` repository

<a href="https://community.chocolatey.org/packages/$reponame"><img src="https://img.shields.io/chocolatey/v/$reponame?style=for-the-badge&logo=chocolatey&label=chocolatey&logoColor=rgba(75%2C0%2C130%2C1)&labelColor=rgba(138%2C43%2C226%2C1)&color=rgba(106%2C90%2C205%2C1)"></a>

```powershell 
Choco install $reponame
```

# Build Artifactes
### Nuget Package

#### Install 📦 [$reponame.$version.nupkg]() using `Install-Package`

```powershell
# Download the Package from the build artifact
Invoke-WebRequest -url "https://$ENV:GITLAB_HOST/$gituser/$reponame/-/jobs/$($ENV:CI_JOB_ID)/artifacts/raw/dist/psgallary/$reponame.$version.nupkg"

# Install the package using install-package
Install-Package -Name $reponame `
                -RequiredVersion $version `
                -Source '\path\to\download' `
                -Destination "$env:USERPROFILE\Documents\PowerShell\Modules\$reponame" `
                -Force

# Import module into powershell session
Import-Module $env:USERPROFILE\Documents\PowerShell\Modules\$reponame -Force
```

#### Install 📦 [$reponame.$version.nupkg]() using `nuget`

```powershell
Invoke-WebRequest -url "https://$ENV:GITLAB_HOST/$gituser/$reponame/-/jobs/$($ENV:CI_JOB_ID)/artifacts/raw/dist/nuget/$reponame.$version.nupkg"

# default windows install location
# - %APPDATA%\NuGet\NuGet
nuget install $reponame -Version $version

Import-Module $env:USERPROFILE\Documents\PowerShell\Modules\$reponame -Force
```

#### Install 📦 [$reponame.$version.zip]() using `zip|7zp|pzip`
```powershell
# Zip
Expand-Archive -Path "\path\to\download\$reponame.$version.nupkg" `
               -DestinationPath "$env:USERPROFILE\Documents\PowerShell\Modules\$reponame"

# 7zip
7z.exe e "\path\to\download\$reponame.$version.nupkg" -o$env:USERPROFILE\Documents\PowerShell\Modules\$reponame

# Import the module
Import-Module $reponame -Force
```

### Nuget Package Chocolatey

#### Install 📦 [$reponame.$version.zip]() using `choco install`

```powershell
# Install from chocolatey nupkg file
# -

# Elevated privileges required - install froms local source
# -
choco install $reponame --version="$version" --source="/download/path/to/.nupkg"

# import the module
Import-Module "C:\ProgramData\chocolatey\lib\$reponame" -Force
```
