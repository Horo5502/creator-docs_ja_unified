(The English translation is below)

> [!WARNING]  
> このリポジトリのsyncブランチに含まれているファイルは **全て** VRChat公式が有するものであり、このリポジトリの管理者が作成したものでは**ありません**。  
> **All** files contained in the sync branch of this repository are owned by official VRChat and were **NOT** created by the administrators of this repository.

# creator-docs_ja_unified
VRChat CreatorDocs統合リポジトリ  
管理者によって同期作業が行われた時点での、全てのVRChatクリエイタードキュメントが含まれています!

## 概要
creator-docs_jaにおける原文の更新を取り込むためのリポジトリ。  
原文追従には、こちらの記事の手法を使わせて頂いている: https://zenn.dev/smikitky/articles/0d250f7367eda9

<!-- おおむね記事の通りに更新作業を行うが、creator-docs_jaでは未翻訳のファイルがまだたくさんあるので、Originフォルダー内の全てをcreator-docs_jaに`git merge`すると、英文のままのMarkdownファイルまでマージされてしまう。   -->
<!-- そのため`copy-target.yml`内に翻訳済みのファイルをパスとともに列挙し、powershellスクリプト(`main.ps1`)を用いてOriginフォルダーから翻訳済みYamlファイルのみをコピーしてプッシュする。 -->

VRChatのクリエイタードキュメントは、4つのリポジトリに分かれている。  
そのままでは更新の取り込みがやりづらいので、このリポジトリに全てのドキュメントを統合し、これをcreator-docs_jaから`git pull`することで、更新を行っている。  
また、creator-docs_jaでは、デプロイの際に、翻訳済のファイルのみを選択してデプロイすることで、未翻訳の英文ファイルがユーザーに表示されないようにしている。

`sync`ブランチが実際の統合済みファイル群である。  
このブランチは、creator-docs_jaの上流ブランチの役割を果たしている。

詳しくはこちら  
https://horo5502.github.io/creator-docs_ja/how-to-contribute/

## このリポジトリをGitの上流ブランチとして使用したい場合
もし、あなたが VRChat Creator Docs を他言語に翻訳するサイトを運営しようと考えており、このリポジトリの `sync` ブランチを上流ブランチとして利用したい場合は、以下の点にご注意ください。

- __私はこのリポジトリの内容について責任を負いません。__

- 現在、このリポジトリは手動で更新されているため、管理者がこのリポジトリの管理を辞めると、ファイルが同期されなくなってしまう可能性があります。

- 同期作業のタイムラグや、手違いにより、原文ファイルの抜け漏れがあるかもしれません。

いつか Github Action を実装して自動同期できるようにしたいと考えていますが、いつできるかはわかりません。(誰かやってくれないかなぁ)

---
---

# creator-docs_ja_unified
VRChat CreatorDocs Unified Repository.  
This repository contains all VRChat creator documents as of the time the synchronization was performed by the administrator!

## Overview
A repository to incorporate updates from the original text in creator-docs_ja.  
It uses the method described in this article to follow the original text updates: https://zenn.dev/smikitky/articles/0d250f7367eda9

<!-- The update work is generally carried out as described in the article, but since there are still many untranslated files in creator-docs_ja, merging everything from the Origin folder into creator-docs_ja with `git merge` will also merge Markdown files that remain in English. -->
<!-- Therefore, we list the translated files with their paths in `copy-target.yml`, and use a PowerShell script (`main.ps1`) to copy and push only the translated YAML files from the Origin folder. -->

VRChat creator documents are divided into four repositories.
But since it is difficult to incorporate updates directly, we integrate all the documents into this repository and update them by running `git pull` from creator-docs_ja.  
Also, in creator-docs_ja, we select and deploy only the translated files during deployment to prevent untranslated English files from being displayed to users.

The sync branch contains the actual integrated files.
This branch serves as the upstream branch for creator-docs_ja.

For more details, visit
https://horo5502.github.io/creator-docs_ja/how-to-contribute/
(Japanese only)

## If you want to use this repository as an upstream branch in Git
If you are considering running a site to translate VRChat Creator Docs into another language and want to use the `sync` branch of this repository as the upstream branch, please be aware of the following:

- __I am NOT responsible for the contents of this repository.__

- Currently, this repository is updated manually, so if the administrator stops managing it, the files may no longer be synchronized.

- There may be a time lag in synchronization or omissions of original files due to mistakes.
- Due to time lags in the synchronization process or human errors, source files may be missing.

I hope to implement GitHub Actions for automatic synchronization someday, but I don't know when that will be.