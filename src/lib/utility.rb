module HtmlSync

  class Utility

    # dir 検索したいディレクトリを指定
    # ftype 検索対象の拡張子を指定するex) .jpg .zip等々
    def self.findFiles(dir,ftype)
      ary = Array.new();

      # /**/* は、指定されたディレクトリ内部のサブディレクトリも返却するために指定が必要。
      Dir::glob(dir + "/**/*").each{|entry|
        next unless entry.match(/#{ftype}/i); # 一致しない場合、スキップする
        ary.push(entry);
      }

      return ary;
    end
    
    # ファイルが存在するかどうかチェックするメソッド。
    # 存在していなければ、例外を返却する
    def self.fileExist?(path)
      if (!File.exist?(path))
        raise Exception, "#{path} is not found.";
      end
    end
    
  end

end
 a s h . e a c h { | s r c f i l e , d s t f i l e |  
              
                 s r c H t m l   =   @ p a r s e r . p a r s e H t m l (   r e a d H t m l ( @ s r c D i r + " / " + s r c f i l e )   ) ;  
                 d s t H t m l   =   @ p a r s e r . p a r s e H t m l (   r e a d H t m l ( @ d s t D i r + " / " + d s t f i l e )   ) ;  
                  
                 d s t H t m l . s y n c S t r   =   s r c H t m l . s y n c S t r ;  
                 w r i t e H t m l ( @ d s t D i r + " / " + d s t f i l e , d s t H t m l . t o _ s ( ) ) ;  
             }                
         e n d  
     e n d  
 e n d  
 