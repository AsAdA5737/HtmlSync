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
   l i n e )   | |   ( / \ A \ n /   = ~   l i n e )   )  
                   n e x t ;  
             e n d  
  
               i f   (   / ( . * ) , ( . * ) /   = ~   l i n e   )  
                   s y n c I n f [ $ 1 ] =   $ 2 ;  
               e l s i f   (   / ( . * ) = ( . * ) /   = ~   l i n e   )  
                   #   i n t e r n o0�eW[R�0�0�0�0�0k0	Y�cY0�0�0�0�0�0 
                   a p p I n f [ $ 1 . i n t e r n ] =   $ 2 ;  
               e n d  
           }  
         f . c l o s e ( ) ;  
                  
         h a s h   =   { : s y n c I n f   = >   s y n c I n f , : a p p I n f   = >   a p p I n f } ;  
         r e t u r n   h a s h ;  
     e n d  
      
     m o d u l e _ f u n c t i o n   : L o a d C o n f i g  
 e n d  
 