module HtmlSync

  # 同期元ディレクトリ
  SRC_DIR="./src";

  # 同期先ディレクトリ  
  DST_DIR="./dst";
    
  # 同期を取るファイルの関連を表す。
  # 同期元ファイル名→同期先ファイル名を表す。
  SYNCFILES = 
    {"kankyo.html"=>"kankyo.html",
     "index.html"=>"index.html"
    }

  # 設定ファイル名
  CONF_FILE_NAME="htmlsync.cfg";
        
  def LoadConfig(file=CONF_FILE_NAME)
    syncInf = Hash.new();
    appInf = Hash.new();
    f = File.open(file)
    f.each{|line|
      if ((/\A#/ =~ line) || (/\A\n/ =~ line) )
         next;
      end

       if ( /(.*),(.*)/ =~ line )
         syncInf[$1]= $2;
       elsif ( /(.*)=(.*)/ =~ line )
         # internは文字列をシンボルに変換するメソッド
         appInf[$1.intern]= $2;
       end
     }
    f.close();
        
    hash = {:syncInf => syncInf,:appInf => appInf};
    return hash;
  end
  
  module_function :LoadConfig
end