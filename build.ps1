#!/usr/bin/env pwsh
param(
    [string]$Runtime = "win-x64",
    [string]$Output = ""
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($Output)) {
    $Output = if ($Runtime -eq "win-x64") {
        Join-Path $PSScriptRoot "Build"
    } else {
        Join-Path $PSScriptRoot "Build-$Runtime"
    }
}

if (Test-Path $Output) {
    Remove-Item -Recurse -Force $Output
}

$publishArgs = @(
    "publish",
    (Join-Path $PSScriptRoot "src/TSMapEditor/TSMapEditor.csproj"),
    "--configuration=Release",
    "--runtime=$Runtime",
    "--no-self-contained",
    "-p:CopyLocalRuntimeTargetAssets=false",
    "--output=$Output"
)

& dotnet @publishArgs
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}
