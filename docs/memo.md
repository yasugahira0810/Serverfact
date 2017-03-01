## host_inventory['user']追加

https://github.com/mizzy/specinfra/commit/340494be494f74e1114f6e1a2f34a6e6514195f6

## アイディア

- namespaceでbefore, after, diffを分けて、taskでhostを指定するやり方だと、  
  事前にhost名のディレクトリを掘るという事前作業が必要。  
  環境変数でhost名渡してディレクトリがない時は作ってもらうようなアーキテクチャーの
  方が使いやすい気がするので、taskでbefore, after, diffを分けて、環境変数でhostを  
  指定するやり方にする。  
  => ツール実行に環境変数の指定が必須なのは如何なものかという感じがしてきたので、  
     上記はやめる。やめて、ディレクトリが存在しないホスト名が指定されたら、  
     エラーで止まるのではなく、全host_inventory&fact実行するような仕組みにする。
- 環境変数で渡したhost名でディレクトリ作って、そこに以下のファイルを保存したい。  
  + info.txt <= 事前に準備してもいいが、なくてもrakeの中で作ってくれる。
  + before.json
  + after.json
  + diff.txt
- jsonを標準出力に吐き出し、それをリダイレクトでファイル保存するようにしたかったが、  
  現状標準出力をリダイレクトしようとすると、json以外に標準出力に出力されるものが  
  jsonの中に入ってしまうため、断念する。json以外の標準出力を抑止する方法がわかれば、  
  標準出力をリダイレクトするような作りに変えたい。
- info.txtにはユーザ名、パスワード、実行対象のhost_inventory, factを記載するつもり  
  だったけど、info.txtという設定ファイルを作ること自体やめる。  
  それぞれ代替の指定の仕方がありそうなことを考慮すると、わざわざ設定ファイルを  
  用意する必要はない気がしてきたため。
  + ユーザ名: SSHのconfig
  + パスワード: spec_helperなり環境変数なり
  + 実行対象のhost_inventory, fact: Rakeでファイルタスクを使って、ファイルがあれば  
    実行対象を限定するようなオプション的なやり方
- こんなタスク設定がいい？

```
rake gather:before
rake gather:after
rake diff:all
rake diff:cpu
rake diff:memory
```
- **思想として、before, afterの情報取得は、取得しておいて損はないので、ユーザに選択権を  
  与えず、全部取ってしまい、diff撮る時に必要なものだけ比較しやすくするつもりでいる。**
- 出力されるjsonはトップレベルで分割した方がいい気がしている。
  + ネストが深くなるの嫌なので、全体的に1つ浅くなるのは嬉しい。
  + ハッシュが同じならまるっと比較すっ飛ばす、みたいな処理ができるようになる。
- 今までbefore, afterでしか考えていなかったが、node#1とnode#2で差分がないか確認したい  
  というケースもあるだろうから、そこにも対応したい。before, afterは引数として取るように  
  するか。。。
- [ここ](http://www.ownway.info/Ruby/rake/arguments)を見ると、rakeにコマンドライン引数を  
  渡す方法は引数定義するか環境変数使うかと記載されている。  
  悩ましいけど、自分以外のユーザに使ってもらうことを考えると、環境変数より引数定義の方が  
  いい気がするので、今回はそう実装する。
  + 引数定義で実装しようとしてRakefikeを改めて確認したところ、Rakeタスクの実行部分が、  
    RSpecによってラッピングされているっぽかった。これで引数定義できるのか、ドキュメントを  
    ちょっと探したくらいではわからなかった。

```
RSpec::Core::RakeTask.new(target.to_sym) do |t|
```

  + そこで、gather部分はRSpec, Serverspecには依存していない気がしたので、脱RSpec, Serverspecを  
    して、Rakeタスクで引数定義をしようとトライした。  
    しかしgather部分もspec_helperにがっつり依存していたので、require部分書き換える必要があり、  
    厳しい感じだった。特にret = Specinfra::Runner.run_command('chkconfig --list').stdoutの  
    実行時にstack level too deep (SystemStackError)というエラーが出て、解決が難しそうだった。  
    なので今回は、引数定義および脱RSpec, Serverspecは断念し、環境変数でTARGET_HOST, TIMINGを  
    渡せるようにしようと思う。TARGET_HOSTディレクトリ配下にTIMING.jsonを吐く感じかな。  
    try_departure_from_serverspecブランチは捨てる。

- RSpecで引数定義する方法が[ここ](https://www.relishapp.com/rspec/rspec-core/docs/command-line/rake-task)にあった。

```ruby
begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec, :tag) do |t, task_args|
    t.rspec_opts = "--tag #{task_args[:tag]}"
  end
rescue LoadError
  # no rspec available
end
```
複数の引数指定もできそう。これで事前にファイルやらディレクトリやら作らずにrake叩けそう。
```ruby
    RSpec::Core::RakeTask.new(target.to_sym, :arg1, :arg2) do |t, b|
      ENV['FACT_TIMING'] = "before"
      ENV['TARGET_HOST'] = original_target
      puts "******** #{b[:arg1]}   **********"
      puts "******** #{b[:arg2]}   **********"
      t.pattern = "spec/gather_fact_spec.rb"
    end
```

gather:TARGET_HOST[TIMING] TARGET_HOSTディレクトリ配下にTIMING.jsonファイルを生成する。
diff:TARGET_HOST[BEFORE,AFTER] TARGET_HOSTディレクトリのBEFORE.jsonとAFTER.jsonのdiffをとる。
別々のTARGET_HOSTのdiffをとりたい場合もあるかもしれないが、そこまでサポートするとツールの  
作りがめちゃめちゃになっちゃいそうなので、その場合はjsonを手動で同じディレクトリに格納して  
もらう設計にしようと思う。

