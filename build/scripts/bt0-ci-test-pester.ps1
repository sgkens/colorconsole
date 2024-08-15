using module ..\keyfile\keyfile.psm1 # Import Get-KeyFromFile
# Pester Configration settings
# _----------------------------_
$Modulename = Get-KeyfromFile -path '.\build\build_config.json' -key 'ModuleName'
# ------------------------------
# Invoke-Pester -CodeCoverage .\libs\*.psm1 -CodeCoverageOutputFile 'Coverage.xml' -CodeCoverageOutputFileFormat JaCoCo -script .\BT0-CI-Test-Pester.ps1 -PassThru
$pesterConfig = New-PesterConfiguration -hashtable @{
  CodeCoverage = @{ 
    Enabled               = $true
    OutputFormat          = 'JaCoCo'
    OutputPath            = 'coverage.xml'
    OutputEncoding        = 'utf8'
    CoveragePercentTarget = 85
    path                  = @(".\libs\cmdlets\*.psm1")
  }
  Run = @{
    # PassThru = $true
    #scriptblock = {'.\test\Test-Unit-Pester.ps1'}
    Path     = '.\test\Unit-tests.ps1';
  }
}
Invoke-Pester -Configuration $pesterConfig
# dotnet tool install -g dotnet-reportgenerator-globaltool
reportgenerator -reports:coverage.xml -targetdir:.\build\temp\coverage_visualizer --title:$Modulename --reporttypes:tmlInline_AzurePipelines ---tag:main