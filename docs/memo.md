# JSONの扱い

- RubyでハッシュをJSONに変換する方法にはto_jsonとJSON.generate(Hash)があるらしい。 
generate_prettyを使いたかったが、厳格なハッシュじゃない（nilとかだ）とERRORが出てしまって  
解消に時間がかかりそうなので、一旦to_jsonを使うことにする。
