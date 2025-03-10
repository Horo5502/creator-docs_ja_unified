# 公式リポジトリが統合されつつあるため、このリポジトリはアーカイブとし、単に公式リポジトリをフォークしたものを新たに用いることとします。
# 移行先: https://github.com/Horo5502/creator-docs-ja

# As the official repository is being merged, this repository will be archived and we will simply use a fork of the official repository.
# New Repository: https://github.com/Horo5502/creator-docs-ja

---
---
---

(The English translation is below)

> [!WARNING]  
> このリポジトリのsyncブランチに含まれているファイルは **全て** VRChat公式が有するものであり、このリポジトリの管理者が作成したものでは**ありません**。  
> **All** files contained in the sync branch of this repository are owned by official VRChat and were **NOT** created by the administrators of this repository.

# creator-docs_ja_unified
VRChat CreatorDocs統合リポジトリ  
Github Actionsによって同期作業が行われた時点での、全てのVRChatクリエイタードキュメントが含まれています!
同期作業は、毎週月曜日の午前0時に自動で行われます。

## 概要
creator-docs_jaにおける原文の更新を取り込むためのリポジトリ。  
原文追従の手順は、こちらの記事の手法を使わせて頂いています: https://zenn.dev/smikitky/articles/0d250f7367eda9

<!-- おおむね記事の通りに更新作業を行うが、creator-docs_jaでは未翻訳のファイルがまだたくさんあるので、Originフォルダー内の全てをcreator-docs_jaに`git merge`すると、英文のままのMarkdownファイルまでマージされてしまう。   -->
<!-- そのため`copy-target.yml`内に翻訳済みのファイルをパスとともに列挙し、powershellスクリプト(`main.ps1`)を用いてOriginフォルダーから翻訳済みYamlファイルのみをコピーしてプッシュする。 -->

VRChatのクリエイタードキュメントは、4つのリポジトリに分かれています。  
そのままでは更新の取り込みがやりづらいので、このリポジトリに全てのドキュメントを統合し、これをcreator-docs_jaから`git pull`することで、更新を行っています。  
また、creator-docs_jaでは、デプロイの際に、翻訳済のファイルのみを選択してデプロイすることで、未翻訳の英文ファイルがサイトに表示されないようにしています。

`sync`ブランチが実際の統合済みファイル群です。  
このブランチは、creator-docs_jaの上流ブランチの役割を果たしています。

詳しくはこちら  
https://horo5502.github.io/creator-docs_ja/how-to-contribute/

## このリポジトリをGitの上流ブランチとして使用したい場合
もし、あなたが VRChat Creator Docs を他言語に翻訳するサイトを運営しようと考えており、このリポジトリの `sync` ブランチを上流ブランチとして利用したい場合は、以下の点にご注意ください。

- __私はこのリポジトリの内容について責任を負いません。__

- 同期作業のタイムラグや、手違いにより、原文ファイルの抜け漏れがあるかもしれません。

このリポジトリは、Github Actionsによって、毎週月曜日の午前0時に公式リポジトリとの同期が行われます。

---
---

# creator-docs_ja_unified
VRChat CreatorDocs Unified Repository.  
This repository contains all VRChat creator documents as of the time the synchronization was performed by Github Actions!
Synchronization occurs automatically every Monday at 0pm.

## Overview
A repository to incorporate updates from the original text in creator-docs_ja.  
It uses the method described in this article to follow the original text updates: https://zenn.dev/smikitky/articles/0d250f7367eda9

<!-- The update work is generally carried out as described in the article, but since there are still many untranslated files in creator-docs_ja, merging everything from the Origin folder into creator-docs_ja with `git merge` will also merge Markdown files that remain in English. -->
<!-- Therefore, we list the translated files with their paths in `copy-target.yml`, and use a PowerShell script (`main.ps1`) to copy and push only the translated YAML files from the Origin folder. -->

VRChat creator documents are divided into four repositories.
But since it is difficult to incorporate updates directly, we integrate all the documents into this repository and update them by running `git pull` from creator-docs_ja.  
Also, creator-docs_ja selects and deploys only translated files during deployment to prevent untranslated English files from appearing on the site.

The sync branch contains the actual integrated files.
This branch serves as the upstream branch for creator-docs_ja.

For more details, visit
https://horo5502.github.io/creator-docs_ja/how-to-contribute/
(Japanese only)

## If you want to use this repository as an upstream branch in Git
If you are considering running a site to translate VRChat Creator Docs into another language and want to use the `sync` branch of this repository as the upstream branch, please be aware of the following:

- __I am NOT responsible for the contents of this repository.__

- Due to time lags in the synchronization process or human errors, source files may be missing.

This repository will be synced with the official repository every Monday at 0pm via Github Actions.
