module HtmlSync
  
  class Syncworker
    
    attr_accessor :srcDir,:dstDir;
    
    def initialize(srcDir,dstDir)
      
      @srcDir = srcDir;
      @dstDir = dstDir;
      @syncHash = nil;
      @parser = HtmlSync::Parser.new();
      @dryrun = false;
      
      HtmlSync::Utility.fileExist?(@srcDir);
      HtmlSync::Utility.fileExist?(@dstDir);
      
    end
    
    # バックアップを実行する
    def backup()
      $logger.debug("file backup");
      ZipFileUtils.zip(@srcDir,"#{@srcDir}.back.zip")
      ZipFileUtils.zip(@dstDir,"#{@dstDir}.back.zip")
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
        
        $logger.info("sync #{@srcDir}/#{srcfile} --> #{@dstDir}/#{dstfile}");        
        srcHtml = @parser.parseHtml( readHtml(@srcDir+"/"+srcfile) );
        dstHtml = @parser.parseHtml( readHtml(@dstDir+"/"+dstfile) );
        
        dstHtml.syncStr = srcHtml.syncStr;
        
        # テストモードであった場合、ファイルへの書き込みを実行しない。
        writeHtml(@dstDir+"/"+dstfile,dstHtml.to_s()) if (!@dryrun);
      }       
      end
  end
end