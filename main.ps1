#Requires -Modules powershell-yaml

# creator-docs_jaのファイル構造に合わせて、Destinationのパスを整形
function PrettifyDestinationPath() {
    param (
        [string]$destpath
    )

    if ($destpath -like "Origin\creator-docs\*") {
        $destpath = $destpath -creplace 'Origin\\creator-docs\\Docs\\', ''
    } elseif ($destpath -like "Origin\UdonSharp\*") {
        $destpath = $destpath -creplace 'Origin\\UdonSharp\\Tools\\Docusaurus\\', ''
        $destpath = $destpath -creplace 'docs\\', 'docs\worlds\udonsharp\'
    } elseif ($destpath -like "Origin\creator-companion\*") {
        $destpath = $destpath -creplace 'Origin\\creator-companion\\Docs\\', ''
        $destpath = $destpath -creplace 'docs', 'docs\vcc\'
    } elseif ($destpath -like "Origin\ClientSim\*") {
        $destpath = $destpath -creplace 'Origin\\ClientSim\\Tools\\Docusaurus\\', ''
        $destpath = $destpath -creplace 'docs', 'docs\clientsim\'
    }

    return $destpath
}

# YAMLデータを解析してコピー操作を実行
function CopyFiles() {
    param (
        [string]$path,
        [hashtable]$data
    )

    foreach ($key in $data.Keys) {
        $value = $data[$key]
        $newPath = Join-Path -Path $path -ChildPath $key
        if ($value -is [System.Collections.Generic.List[System.Object]]) {
            $stringvalue = $value | Where-Object { $_ -is [String]}
            foreach ($s in $stringvalue) {
                # ファイルをコピー
                $source = Join-Path -Path $newPath -ChildPath "$s.md"
                $source = $source -replace 'Documentation\\|Extra\\|Getting-Started\\', ''
                $destinationDir = PrettifyDestinationPath -destpath $newPath
                $destination = Join-Path -Path $destinationDir -ChildPath "$s.md"
                if (!(Test-Path $destinationDir)) {
                    Write-Host -NoNewline -ForegroundColor Green "MKDIR:   "
                    Write-Host $destinationDir
                    New-Item -ItemType Directory -Force -Path $destinationDir | Out-Null
                }
                $destination = Join-Path -Path $destinationDir -ChildPath "$s.md"
                Copy-Item -Path $source -Destination $destination -Force
                Write-Host -NoNewline -ForegroundColor Green "COPY:    "
                Write-Host "source = $source,   destination = $destination"
                Copy-Item -Path $source -Destination $destination -Force
            }

            foreach ($v in $value) {
                if ($v -is [hashtable]) {
                    CopyFiles -path $newPath -data $v
                }
            }

        } elseif ($value -is [hashtable]) {
            # 再帰的にディレクトリを探索
            CopyFiles -path $newPath -data $value
        }
    }
}



$staticSourceDest = @(
    @{Source = "Origin\creator-docs\Docs\static\*"; Destination = "static\img"},
    @{Source = "Origin\UdonSharp\Tools\Docusaurus\static\*"; Destination = "static\img_usharp"},
    @{Source = "Origin\creator-companion\Docs\static\*"; Destination = "static\img_vcc"},
    @{Source = "Origin\ClientSim\Tools\Docusaurus\static\*"; Destination = "static\img_clientsim"}
)

# Gitのローカルリポジトリを最新に更新
# Write-Host -ForegroundColor Green "Update local Git repositories"
# Set-Location $PSScriptRoot\Origin\creator-docs
# git fetch origin main
# git reset --hard origin/main
# Set-Location $PSScriptRoot\Origin\UdonSharp
# git fetch origin master
# git reset --hard origin/master
# Set-Location $PSScriptRoot\Origin\creator-companion
# git fetch origin main
# git reset --hard origin/main
# Set-Location $PSScriptRoot\Origin\ClientSim
# git fetch origin main
# git reset --hard origin/main
# Set-Location $PSScriptRoot
# Write-Host "`n`n"

# 静的ファイルをコピー
write-Host -ForegroundColor Green "Copy static files"
foreach ($sourcedest in $staticSourceDest) {
    Write-Host -NoNewline -ForegroundColor Green "COPY:    "
    Write-Host "source = $($sourcedest["Source"]),   destination = $($sourcedest["Destination"])"
    Copy-Item -Path $($sourcedest["Source"]) -Destination $($sourcedest["Destination"]) -Recurse -Force
}
Write-Host "`n`n"

# copy-target.ymlを読み込んで、ファイルをコピー
$yamlData = ConvertFrom-Yaml ((Get-Content (Join-Path $PSScriptRoot "copy-target.yml")) -join "`n")
Write-Host -ForegroundColor Green "Copy markdown files"
CopyFiles -path 'Origin' -data $yamlData