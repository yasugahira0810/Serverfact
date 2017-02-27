## host_inventory['user']追加

https://github.com/mizzy/specinfra/commit/340494be494f74e1114f6e1a2f34a6e6514195f6

## アイディア

- namespaceでbefore, after, diffを分けて、taskでhostを指定するやり方だと、  
  事前にhost名のディレクトリを掘るという事前作業が必要。  
  環境変数でhost名渡してディレクトリがない時は作ってもらうようなアーキテクチャーの
  方が使いやすい気がするので、taskでbefore, after, diffを分けて、環境変数でhostを  
  指定するやり方にする。  
- 環境変数で渡したhost名でディレクトリ作って、そこに以下のファイルを保存したい。  
  + info.txt <= 事前に準備してもいいが、なくてもrakeの中で作ってくれる。
  + before.json
  + after.json
  + diff.txt
