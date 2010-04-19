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
    
    # バックアップとして、ファイルを圧縮してコピーしておく。
    def backup()
      $logger.debug("file backup");
      ZipFileUtils.zip(@srcDir,"#{@srcDir}.back.zip")
      ZipFileUtils.zip(@dstDir,"#{@dstDir}.back.zip")
      $logger.debug("backup OK");
      return self;
    end
    
    # HTMLファイルを読み込む
    def readHtml(htmlFilePath)
      HtmlSync::Utility.fileExist?(htmlFilePath);
      
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
    
     # テストモードにする
    def dryrun()
      @dryrun = true;
      return self;
    end
    # ファイルの同期を実行
    def sync()
      @syncHash.each{|srcfile,dstfile|
        
        # テストモード。実際に書き出しは行わず、チェックのみ実行する
        if (@dryrun)
          $logger.info("sync #{@srcDir}/#{srcfile} --> #{@dstDir}/#{dstfile}");
          next;
        end
        
        srcHtml = @parser.parseHtml( readHtml(@srcDir+"/"+srcfile) );
        dstHtml = @parser.parseHtml( readHtml(@dstDir+"/"+dstfile) );
        
        dstHtml.syncStr = srcHtml.syncStr;
        writeHtml(@dstDir+"/"+dstfile,dstHtml.to_s());
      }       
    end
  end
end
 er.info("Finished");

rescue Exception => ex
  $logger.error("Error Occurred.");
  $logger.error(ex.message);
end
 ());
      }       
    end
  end
end
 Syncworker.new(HtmlSync::SRC_DIR,HtmlSync::DST_DIR);
syncworker.backup(); # �t�@�C�����o�b�N�A�b�v

if (File.exist?(File::expand_path(HtmlSync::CONF_FILE_NAME)))
  syncworker.setSyncFiles(HtmlSync::LoadConfig()).sync(); # �������s
else
  syncworker.setSyncFiles(HtmlSync::SYNCFILES).sync(); # �������s
end

$logger.info("Finished");
 urn props
  else
    opt.usage()
    exit(1)
  end
end

# Logger�̏�����
def startupLogger(props)

  $logger = Logger.new(STDOUT)
  $logger.datetime_format = "%Y/%m/%d %H:%M:%S";  
  if (props[:debug])
    $logger.level = Logger::DEBUG
    $logger.debug("entering debug mode");
  else
    $logger.level = Logger::INFO
  end
end

#�����̉��
props = parseOption(ARGV);

#Logger����
startupLogger(props);

#���O�ւ̏�����񏑂��o��
$logger.info("================================");
$logger.info("       Html Sync #{Version}     ");
$logger.info("================================");

if (props[:dry_run])
  puts "TBD. Test mode here"  
end

syncworker = HtmlSync::Syncworker.new(HtmlSync::SRC_DIR,HtmlSync::DST_DIR);
syncworker.backup(); # �t�@�C�����o�b�N�A�b�v

if (File.exit?(File::expand_path(HtmlSync::CONF_FILE_NAME)))
  syncworker.setSyncFiles(HtmlSync::LoadConfig()).sync(); # �������s
else
  syncworker.setSyncFiles(HtmlSync::SYNCFILES).sync(); # �������s
end

$logger.info("Finished");
