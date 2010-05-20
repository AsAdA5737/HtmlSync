#
# Class:backup
# Date :2010-05-15 11:51:14+09:00
#

# Backupユーティリティ
# 機能:
#   * 複数のファイル(ディレクトリ)をひとつのディレクトリにまとめて、一気に圧縮可能。
#   * 指定した世代数でバックアップを実行する
#

require 'temp_dir'
require 'ZipFileUtils'

module AUtility

  DefaultFilePath=File.dirname(File.expand_path($PROGRAM_NAME)) + "/backup_" + Time.now.strftime("%y%m%d") + ".zip";

  class Backup

    attr_accessor :genNum    # 世代数を指定する

    def initialize()
      @genNum = 10;          #デフォルト10世代まで残すことにする。
      @entry = nil;  # バックアップを取るファイル(ディレクトリ)のパスを保持する
    end

    public # これ以降はpublicメソッドとして公開する。指定しない場合、通常public指定。
    # backアップを実行する
    # outPath:任意のzipファイルパスを指定可能。省略した場合、カレントに出力する
    # 絶対パスを指定した場合、どうなる？？
    def backup(zipfile=DefaultFilePath)

      TempDir.create do |dir|
        # 一時ディレクトリにバックアップ対象をコピーする
        FileUtils.cp_r(@entry,dir);

        # 一時ディレクトリの中身を、まとめてzipファイル化する。
        #その前にログをlotateする
        rotate(zipfile);

        # 圧縮
        ZipFileUtils.zip( dir, zipfile );
        
      end

      return self;
    end

    # backアップを実行するファイルを追加する
    # 引数の数は任意。ただし、１つ以上のファイルは指定する必要あり。
    def addFiles(ary)
      if (ary.length == 0)
        raise ArgumentError, "Invalid argument. lenght == 0 is invalid";
      end

      # Pathname Object -> 絶対パス文字列に変換する
      @entry = ary.map{|path| path.realpath}
      return self;
    end

    private  # これ以降はprivateメソッドとして公開する。
    # zipファイルの名前(絶対パス)を返却するメソッド
    def rotate(zipfile)
      hash = Hash.new();

      # 処理は何もしない
      if !(File.exist?(zipfile))
        return nil;
      end

      # 空いているファイルの番号を検索する
      emptyNum = findFileNumber(zipfile);
      
      for index in 1..emptyNum
        extzipfile = getPathAddIndex(zipfile,index-1);
        hash[extzipfile] = getPathAddIndex(zipfile,index);
      end
      
      hash.to_a.sort{|a,b|  # ソート
        getIndexByFname(b[1]) <=> getIndexByFname(a[1])  # (1)と(10)を比較した場合、うまくsortできないため、数字を数字を実際に切り出して比較する
      }.each{|from,to|
        File.rename(from,to)  # lotate前ファイルをlotate後ファイルに名前を変更する
      }

      # 世代数を超えてしまったファイルは削除する。
      if (File.exist?(file = getPathAddIndex(zipfile,@genNum)))
        File.delete(file);
      end
    end

    # 与えられたファイル名から、空き番号を探す。
    def findFileNumber(zipfile)      
      for index in 1..@genNum-1
        extzipfile = getPathAddIndex(zipfile,index);

        if (!File.exist?(extzipfile)) # ファイルが存在するかチェック
          return index;
        end
      end
      return @genNum;
    end

    # ファイル名にindex番号を足したファイル名を返却する。
    # たとえば、XXXX/YYYY.zip -> XXXX/YYYY(1).zip
    # http://old.nabble.com/-ruby-list:44608--Pathname-%E3%81%A7%E6%8B%A1%E5%BC%B5%E5%AD%90%E3%82%92%E5%A4%89%E6%9B%B4%E3%81%99%E3%82%8B-td15405713.html
    # ↑上記の方法がスマート？
    def getPathAddIndex(file,index)
      if (index == 0)
        return file;
      else
        return File.dirname(file) + "/" + File.basename(file,".zip") + "(#{index}).zip";
      end
    end
    
    # ファイルパスから、indexを取り出す。
    def getIndexByFname(path)
      if (path =~ /\((\d+)\).zip\z/)
        return $1.to_i();
      else
        return @genNum;
      end
    end
  end
end