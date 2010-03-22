module HtmlSync
  
  class Syncworker
    
    attr_accessor :srcDir,:dstDir;
    
    def initialize(srcDir,dstDir)
      
      @srcDir = srcDir;
      @dstDir = dstDir;
      @syncHash = nil;
      @parser = HtmlSync::Parser.new();
      
    end
    
    # バックアップとして、ファイルを圧縮してコピーしておく。
    def backup()
      $logger.debug("file backup");
      ZipFileUtils.zip(@srcDir,"srcdir.back.zip")
      ZipFileUtils.zip(@dstDir,"dstdir.back.zip")
      $logger.debug("backup OK");
      return self;
    end
    
    # HTMLファイルを読み込む
    def readHtml(htmlFilePath)
      open(htmlFilePath,"r"){|io|
        return io.readlines().join();
      }
    end
    
    # ファイルに文字列を出力する
    def writeHtml(htmlFilePath,outputStr)
      open(htmlFilePath,"w+"){|io|
        io.write(outputStr);
      }      
    end
    
    # 同期させるファイルをHash形式で指定する
    def setSyncFiles(fileSetHash)
      @syncHash = fileSetHash;
      return self;
    end
    
    # ファイルの同期を実行
    def sync()
      @syncHash.each{|srcfile,dstfile|
        srcHtml = @parser.parseHtml( readHtml(@srcDir+"/"+srcfile) );
        dstHtml = @parser.parseHtml( readHtml(@dstDir+"/"+dstfile) );
        
        dstHtml.syncStr = srcHtml.syncStr;
        writeHtml(@dstDir+"/"+dstfile,dstHtml.to_s());
      }       
    end
  end
end