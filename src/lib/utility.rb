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
  end

end