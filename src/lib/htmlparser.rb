module HtmlSync

  class Parser

    #<!-- startTag -->〜 <!-- /endTag -->を抜き出す。
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