param (
    # creator-docs_ja_unifiedローカルリポジトリのルートディレクトリのパス(Github Actionsのために追加)
    [string]$workingDirPath = $PSScriptRoot,
    [string]$categoryJsonPath = "$PSScriptRoot\usharp_category.json"
)

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


$staticSourceDest = @(
    @{Source = "Origin\creator-docs\Docs\static\img\*"; Destination = "static\img_creator-docs"},
    @{Source = "Origin\UdonSharp\Tools\Docusaurus\static\images\*"; Destination = "static\img_usharp"},
    @{Source = "Origin\creator-companion\Docs\static\images\*"; Destination = "static\img_vcc"},
    @{Source = "Origin\ClientSim\Tools\Docusaurus\static\images\*"; Destination = "static\img_clientsim"}
)

$markdownSourceDest = @(
    @{Source = "Origin\creator-docs\Docs\docs\*"; Destination = "docs_all\"},
    @{Source = "Origin\creator-companion\Docs\docs\*"; Destination = "docs_all\vcc"},
    @{Source = "Origin\ClientSim\Tools\Docusaurus\docs\*"; Destination = "docs_all\clientsim"}
)

$repositoryInfo = @(
    @{Name = "creator-docs"; URL = "https://github.com/vrchat-community/creator-docs.git"},
    @{Name = "UdonSharp"; URL = "https://github.com/vrchat-community/UdonSharp.git"},
    @{Name = "creator-companion"; URL = "https://github.com/vrchat-community/creator-companion.git"},
    @{Name = "ClientSim"; URL = "https://github.com/vrchat-community/ClientSim.git"}
)



# Gitのローカルリポジトリを最新に更新
Write-Host -ForegroundColor Green "Update local Git repositories"

$repoParentDir = "$workingDirPath\Origin"

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

Set-Location $workingDirPath
Write-Host "`n`n"

# docs,staticフォルダをクリア
Remove-Item -Path "$workingDirPath\docs_all\" -Recurse -Force
Remove-Item -Path "$workingDirPath\static\" -Recurse -Force

# 静的ファイルをコピー
write-Host -ForegroundColor Green "Copy static files"
foreach ($sourcedest in $staticSourceDest) {
    Write-Host -NoNewline -ForegroundColor Green "COPY:    "
    Write-Host "source = $($sourcedest["Source"]),   destination = $($sourcedest["Destination"])"

    MakeDirectoryIfNotExists -dirpath $($sourcedest["Destination"])
    Copy-Item -Path $($sourcedest["Source"]) -Destination $($sourcedest["Destination"]) -Recurse -Force
}
Write-Host "`n`n"

# Markdownをコピー
foreach ($sourcedest in $markdownSourceDest) {
    Write-Host -NoNewline -ForegroundColor Green "COPY:    "
    Write-Host "source = $($sourcedest["Source"]),   destination = $($sourcedest["Destination"])"

    MakeDirectoryIfNotExists -dirpath $($sourcedest["Destination"])
    Copy-Item -Path $($sourcedest["Source"]) -Destination $($sourcedest["Destination"]) -Recurse -Force
}


# UdonSharpだけはカテゴリ分けが必要なので別個で処理
$legacyDocsDir = "$workingDirPath\docs_all\worlds\udon\udonsharp\legacy-docs"
Write-Host -NoNewline -ForegroundColor Green "MKDIR:   "
Write-Host $legacyDocsDir
New-Item -ItemType Directory -Force -Path $legacyDocsDir | Out-Null

$jsonContent = Get-Content -Path $categoryJsonPath -Raw | ConvertFrom-Json
foreach ($file in Get-ChildItem -Path "$workingDirPath\Origin\UdonSharp\Tools\Docusaurus\docs" -File) {
    $mdcategory = ""
    $fileName = $file.Name -replace ".md", ""

    if ($fileName -eq "index") {
        Write-Host -NoNewline -ForegroundColor Green "COPY:    "
        Write-Host "source = $($file.FullName),   destination = $legacyDocsDir\UdonSharp.md"
        Copy-Item -Path $file.FullName -Destination "$legacyDocsDir\UdonSharp.md"
        continue
    }

    # jsonファイルから$fileNameのカテゴリを取得(Getting-Started, Documentation, Extra)
    foreach ($category in $jsonContent.PSObject.Properties) {
        if ($category.Value -contains $fileName) {
            $mdcategory = $category.Name
            break
        }
    }
    $destPath = "$legacyDocsDir\$mdcategory\$fileName.md"

    if (!($mdcategory -eq "")) {
        Write-Host -NoNewline -ForegroundColor Green "COPY:    "
        Write-Host "source = $($file.FullName),   destination = $destPath"

        MakeDirectoryIfNotExists -dirpath "$legacyDocsDir\$mdcategory"
        Copy-Item -Path $file.FullName -Destination $destPath
    }
}



# いらないものを削除
Write-Host -NoNewline -ForegroundColor Green "DELETE:    "
Write-Host "$workingDirPath\docs_all\clientsim\logo.png"

Remove-Item -Path "$workingDirPath\docs_all\clientsim\logo.png"

# Originフォルダ等がGitの追跡対象にならないように、.gitignoreを作成
if (!(Test-Path "$workingDirPath\.gitignore")) {
    Write-Host -NoNewline -ForegroundColor Green "MKFILE:   "
    Write-Host "$workingDirPath\.gitignore"

    New-Item -ItemType File -Force -Path "$workingDirPath\.gitignore" | Out-Null
    Add-Content -Path "$workingDirPath\.gitignore" -Value ".gitignore`nOrigin`nunify.ps1`nusharp_category.json"
}