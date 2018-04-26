Write-Output "Downloading test repo release artifacts by tag"

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$repoName = "Test_private_repo"
$repoUrl = "https://github.com/GrigoriyYepick/$repoName"
$latestRelease = Invoke-WebRequest $repoUrl/releases/tag/release_v1.0 -Headers @{"Accept"="application/json"}
$json = $latestRelease.Content | ConvertFrom-Json
$latestVersion = $json.tag_name

$output = "Repo url: " + $repoUrl
Write-Output $output

$output = "Latest version name: " + $latestVersion
Write-Output $output

$url = "$repoUrl/archive/$latestVersion.zip"
<#$download_path = "$env:USERPROFILE\Downloads\pester-master.zip"#>
$download_dir = "C:\Temp\#Downloads"
$download_path = "$download_dir\test_repo.zip"

$output = "Release artifact url: " + $url
Write-Output $output

Invoke-WebRequest -Uri $url -OutFile $download_path

Get-Item $download_path | Unblock-File

<#$user_module_path = $env:PSModulePath -split ";" -match $env:USERNAME -notmatch "vscode"#>
$user_module_path = "$download_dir\modules"

$output = "Create modules path: " + $user_module_path
Write-Output $output

if (-not (Test-Path -Path $user_module_path))
{
    New-Item -Path $user_module_path -ItemType Container | Out-Null
}

Write-Output "Unpack release archive"
Expand-Archive -Path $download_path -DestinationPath $user_module_path -Force

