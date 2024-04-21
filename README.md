# creator-docs_ja_unified
VRChat CreatorDocs統合リポジトリ  
**注意**: このリポジトリはcreator-docs_jaの管理用であるため、公式リポジトリ内の一部のファイルしか含まれていません。

# What's this?
creator-docs_jaにおける原文の更新を取り込むためのリポジトリ。  
原文追従には、こちらの記事の手法を使わせて頂いている: https://zenn.dev/smikitky/articles/0d250f7367eda9

おおむね記事の通りに更新作業を行うが、creator-docs_jaでは未翻訳のファイルがまだたくさんあるので、Originフォルダー内の全てをcreator-docs_jaに`git merge`すると、英文のままのMarkdownファイルまでマージされてしまう。  
そのため`copy-target.yml`内に翻訳済みのファイルをパスとともに列挙し、powershellスクリプト(`main.ps1`)を用いてOriginフォルダーから翻訳済みYamlファイルのみをコピーしてプッシュする。

syncブランチが実際の統合済みファイル群である。  
このブランチは、実質的にcreator-docs_jaのupstreamリポジトリの役割を果たしている。

詳しくはこちら  
https://horo5502.github.io/creator-docs_ja/how-to-contribute/