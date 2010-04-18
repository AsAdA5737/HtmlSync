module HtmlSync

  class Parser

    #<!-- startTag -->? <!-- /endTag -->を抜き出す。
    attr_accessor :startTag,:endTag;
      
    def initialize()
      @startTag = "SYNCHTML"
      @endTag = "/SYNCHTML"      
    end

    # HTMLファイルを解析する
    def parseHtml(htmlStr)
      
      html = Html.new();
      
      html.srcTxt = htmlStr;
      # open(htmlFilePath,"r"){|io|
      #  html.srcTxt = io.readlines().join();
      #}
      
      # 正規表現で、同期する部分の文字列をチェックする
       %r|(.*)(<!--\s*#{@startTag}\s*-->.*<!--\s*#{@endTag}\s*-->)(.*)|m =~ htmlStr;
      
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
end
 rcTxt;
  
    def initialize()
    
    end
  
    def to_s()
      return @headerStr <<  @syncStr <<  @footerStr;    
    end
  end
end
 Tag = "SYNCHTML"
      @endTag = "/SYNCHTML"      
    end

    # HTML�t�@�C������͂���
    def parseHtml(htmlStr)
      
      html = Html.new();
      
      html.srcTxt = htmlStr;
      # open(htmlFilePath,"r"){|io|
      #  html.srcTxt = io.readlines().join();
      #}
      
      # ���K�\���ŁA�������镔���̕�������`�F�b�N����
       %r|(.*)(<!--\s*#{@startTag}\s*-->.*<!--\s*#{@endTag}\s*-->)(.*)|m =~ htmlStr;
      
      html.headerStr = $1;
      html.syncStr = $2;
      html.footerStr = $3;      
      
      return html;
    end
    
  end

  # HTML�t�@�C����\������N���X
  class Html
  
    attr_accessor :syncStr, :headerStr, :footerStr, :srcTxt;
  
    def initialize()
    
    end
  
    def to_s()
      return @headerStr <<  @syncStr <<  @footerStr;    
    end
  end
end props = parseOption(ARGV);

#Logger準備
startupLogger(props);

#ログへの初期情報書き出し
$logger.info("================================");
$logger.info("       Html Sync #{Version}     ");
$logger.info("================================");

if (props[:dry_run])
  puts "TBD. Test mode here"  
end

syncworker = HtmlSync::Syncworker.new(HtmlSync::SRC_DIR,HtmlSync::DST_DIR);
syncworker.backup(); # ファイルをバックアップ

if (File.exist?(File::expand_path(HtmlSync::CONF_FILE_NAME)))
  syncworker.setSyncFiles(HtmlSync::LoadConfig()).sync(); # 同期実行
else
  syncworker.setSyncFiles(HtmlSync::SYNCFILES).sync(); # 同期実行
end

$logger.info("Finished");
t