require 'pathname' 

module HtmlSync
  
  class Syncworker
    
    attr_accessor :srcDir,:dstDir,:backUp;
    
    def initialize(srcDir,dstDir)
      
      @srcDir = srcDir;
      @dstDir = dstDir;
      @syncHash = nil;
      @parser = HtmlSync::Parser.new();
      @dryrun = false;
      @backUp = AUtility::Backup.new();
      HtmlSync::Utility.fileExist?(@srcDir);
      HtmlSync::Utility.fileExist?(@dstDir);      
    end
    
    # バックアップを実行する
    def backup()
      $logger.debug("file backup");

      # No arguments should be given; the old behaviour is *obsoleted*. 
      #
      #def realpath
      #  path = @path
      #       :
      #  prefix, *names = realpath_rec(prefix, names, {})
      #  self.class.new(prepend_prefix(prefix, File.join(*names)))
      #end
      # 廃止になっているっぽい。
            
      @backUp.addFiles([Pathname.new(@srcDir),Pathname.new(@dstDir)]).backup() if (!@dryrun);
      $logger.debug("backup OK");
      return self;
    end
    
    # ファイルからHTMLを読み込む
    def readHtml(htmlFilePath)
      HtmlSync::Utility.fileExist?(htmlFilePath);
      
      open(htmlFilePath,"r"){|io|
        return io.readlines().join();
      }
    end
    
    # ファイルへHTMLを書き込む
    def writeHtml(htmlFilePath,outputStr)
      open(htmlFilePath,"w+"){|io|
        io.write(outputStr);
      }      
    end
    
    # 同期対象のファイルHashリストをセットする
    def setSyncFiles(fileSetHash)
      @syncHash = fileSetHash;
      return self;
    end
    
     # テストモードをセットする
    def dryrun()
      @dryrun = true;
      return self;
    end
    
    # 同期を取る。
    def sync()
      @syncHash.each{|srcfile,dstfile|
        srcHtml = @parser.parseHtml( readHtml(@srcDir+"/"+srcfile) );
        dstHtml = @parser.parseHtml( readHtml(@dstDir+"/"+dstfile) );
        
        # 同期対象の文字列を比較する。
        # 同じ文字列であれば、比較せずそのファイルをスキップする。
        if (srcHtml.syncStr == dstHtml.syncStr)
          $logger.info("skip : #{@srcDir}/#{srcfile} , #{@dstDir}/#{dstfile} has same contens ");        
          next;
        end
        
        dstHtml.syncStr = srcHtml.syncStr;
        
        $logger.info("sync : #{@srcDir}/#{srcfile} --> #{@dstDir}/#{dstfile}");
        # テストモードであった場合、ファイルへの書き込みを実行しない。
        writeHtml(@dstDir+"/"+dstfile,dstHtml.to_s()) if (!@dryrun);
      }       
      end
  end
end