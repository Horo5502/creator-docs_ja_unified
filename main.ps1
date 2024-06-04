#Requires -Modules powershell-yaml

# creator-docs_jaのファイル構造に合わせて、Destinationのパスを整形
function PrettifyDestinationPath() {
    param (
        [string]$destpath
    )

    if ($destpath -like "Origin\creator-docs\*") {
        $destpath = $destpath -creplace 'Origin\\creator-docs\\Docs\\', ''
        $destpath = $destpath -creplace 'docs', 'docs_all'
    }
    elseif ($destpath -like "Origin\UdonSharp\*") {
        $destpath = $destpath -creplace 'Origin\\UdonSharp\\Tools\\Docusaurus\\', ''
        $destpath = $destpath -creplace 'docs', 'docs_all\worlds\udonsharp'
    }
    elseif ($destpath -like "Origin\creator-companion\*") {
        $destpath = $destpath -creplace 'Origin\\creator-companion\\Docs\\', ''
        $destpath = $destpath -creplace 'docs', 'docs_all\vcc'
    }
    elseif ($destpath -like "Origin\ClientSim\*") {
        $destpath = $destpath -creplace 'Origin\\ClientSim\\Tools\\Docusaurus\\', ''
        $destpath = $destpath -creplace 'docs', 'docs_all\clientsim'
    }

    return $destpath
}

# 与えられたパスを構成するディレクトリが存在しない場合に作成
function MakeDirectoryIfNotExists {
    param (
        [string]$dirpath
    )
    
    if (!(Test-Path $dirpath)) {
        Write-Host -NoNewline -ForegroundColor Green "MKDIR:   "
        Write-Host $dirpath
        New-Item -ItemType Directory -Force -Path $dirpath | Out-Null
    }
}

# YAMLデータを解析してコピー操作を実行
function CopyFilesFromYaml {
    param (
        [string]$path,
        [hashtable]$data
    )

    foreach ($key in $data.Keys) {
        $value = $data[$key]
        $newPath = Join-Path -Path $path -ChildPath $key


        if ($value -is [hashtable]) {
            # 再帰的にディレクトリを探索
            CopyFilesFromYaml -path $newPath -data $value
        }

        elseif ($value -is [System.Collections.Generic.List[System.Object]]) {
            # リスト内にはハッシュテーブルも含まれている可能性があるので、ファイル名文字列のみを抽出
            $stringvalue = $value | Where-Object { $_ -is [String]}

            foreach ($s in $stringvalue) {
                $source = Join-Path -Path $newPath -ChildPath "$s.md"

                # U#の特殊フォルダはsourceには無く、そのままだとNotFoundになるので、消去
                $source = $source -replace 'Documentation\\|Extra\\|Getting-Started\\', ''

                $destinationDir = PrettifyDestinationPath -destpath $newPath
                $destination = Join-Path -Path $destinationDir -ChildPath "$s.md"

                MakeDirectoryIfNotExists -dirpath $destinationDir

                Write-Host -NoNewline -ForegroundColor Green "COPY:    "
                Write-Host "source = $source,   destination = $destination"
                Copy-Item -Path $source -Destination $destination -Force
            }

            foreach ($v in $value) {
                if ($v -is [hashtable]) {
                    # 再帰的にディレクトリを探索
                    CopyFilesFromYaml -path $newPath -data $v
                }
            }
        }
    }
}



$staticSourceDest = @(
    @{Source = "Origin\creator-docs\Docs\static\img\*"; Destination = "static\img_creator-docs"},
    @{Source = "Origin\UdonSharp\Tools\Docusaurus\static\images\*"; Destination = "static\img_usharp"},
    @{Source = "Origin\creator-companion\Docs\static\images\*"; Destination = "static\img_vcc"},
    @{Source = "Origin\ClientSim\Tools\Docusaurus\static\images\*"; Destination = "static\img_clientsim"}
)

$repositoryInfo = @(
    @{Name = "creator-docs"; URL = "https://github.com/vrchat-community/creator-docs.git"},
    @{Name = "UdonSharp"; URL = "https://github.com/vrchat-community/UdonSharp.git"},
    @{Name = "creator-companion"; URL = "https://github.com/vrchat-community/creator-companion.git"},
    @{Name = "ClientSim"; URL = "https://github.com/vrchat-community/ClientSim.git"}
)



# Gitのローカルリポジトリを最新に更新
Write-Host -ForegroundColor Green "Update local Git repositories"

$repoParentDir = "$PSScriptRoot\Origin"

# 初回実行時にはリポジトリをクローン
if (!(Test-Path $repoParentDir)) {
    New-Item -ItemType Directory -Force -Path $repoParentDir | Out-Null
    Set-Location $repoParentDir
    foreach ($info in $repositoryInfo) {
        git clone $info["URL"]
    }
}
# 2回目以降はリポジトリを更新
else {
    foreach ($info in $repositoryInfo) {
        $repoDir = Join-Path -Path $repoParentDir -ChildPath $info["Name"]

        Set-Location $repoDir

        # UdonSharpリポジトリだけデフォルトブランチがmasterなので、分岐
        if ($repoDir -like "*UdonSharp*") {
            git fetch origin master
            git reset --hard origin/master
        }
        else {
            git fetch origin main
            git reset --hard origin/main
        }
    }
}

Set-Location $PSScriptRoot
Write-Host "`n`n"

# docs,staticフォルダをクリア
Remove-Item -Path "$PSScriptRoot\docs_all\" -Recurse -Force
Remove-Item -Path "$PSScriptRoot\static\" -Recurse -Force

# 静的ファイルをコピー
write-Host -ForegroundColor Green "Copy static files"
foreach ($sourcedest in $staticSourceDest) {
    Write-Host -NoNewline -ForegroundColor Green "COPY:    "
    Write-Host "source = $($sourcedest["Source"]),   destination = $($sourcedest["Destination"])"

    MakeDirectoryIfNotExists -dirpath $($sourcedest["Destination"])
    Copy-Item -Path $($sourcedest["Source"]) -Destination $($sourcedest["Destination"]) -Recurse -Force
}
Write-Host "`n`n"

# copy-target.ymlを読み込んで、ファイルをコピー
$yamlData = ConvertFrom-Yaml ((Get-Content (Join-Path $PSScriptRoot "copy-target.yml")) -join "`n")
Write-Host -ForegroundColor Green "Copy markdown files"
CopyFilesFromYaml -path 'Origin' -data $yamlData