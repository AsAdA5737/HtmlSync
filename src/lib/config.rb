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
  CONF_FILE_NAME="syncfile.inf";
        
  def LoadConfig(file=CONF_FILE_NAME)
    hash = Hash.new();
    f = File.open(file)
    f.each{|line|
      if ((/\A#/ =~ line) || (/\A\n/ =~ line) )
         next;
      end

       /(.*),(.*)/ =~ line;
       hash[$1]= $2;
     }
    f.close();
        
    return hash;
  end
  
  module_function :LoadConfig
  
end
 {@endTag}\s*-->)(.*)|m =~ htmlStr;
      
      html.headerStr = $1;
      html.syncStr = $2;
      html.footerStr = $3;      
      
      return html;
    end
    
  end

  # HTMLファイルを表現するクラス
  class Html
  
    attr_accessor :syncStr, :headerStr, :footerStr, :srcTxt;
  
    def initialize()
    
    end
  
    def to_s()
      return @headerStr <<  @syncStr <<  @footerStr;    
    end
  end
end�