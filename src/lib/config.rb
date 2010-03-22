module HtmlSync

  # 同期元ディレクトリ
  SRC_DIR="./internal";

  # 同期先ディレクトリ  
  DST_DIR="./external";
    
  # 同期を取るファイルの関連を表す。
  # 同期元ファイル名→同期先ファイル名を表す。
  SYNCFILES = 
    {"kankyo.html"=>"kankyo.html",
     "index.html"=>"index.html"
    }
    
end