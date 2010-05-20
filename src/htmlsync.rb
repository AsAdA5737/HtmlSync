#!/usr/bin/ruby
#
# 必要モジュール
# * rubyzip
#   for mac, install modules
#     -> sudo port install rb-rubygems
#     -> sudo port install rb-zip
#   for windows 
#     -> gem install rubyzip
# * tempdir
#   for windows 
#     -> gem install tempdir
#   
# 
# メモ
# 　Invalid char \273\ in expressionと出る場合
# 　http://www.skymerica.com/blog/yotsumoto/arch/2007/05/08/000765.html
#   
# バージョン履歴(1.X:Xが奇数だと、テスト版、偶数になると安定版とする)
# 1.0.0 : 初版
# 1.1.0 : 出力強化、テストモード時バックアップを取らないように変更
# 1.1.1 : 世代バックアップをとるよう実装変更

Version="1.1.1";

$LOAD_PATH << File.join(File.dirname(__FILE__),"lib");

require "rubygems"
require 'optparse'
require 'logger'
require 'htmlparser'
require 'config'
require 'utility'
require 'syncworker'
require 'ZipFileUtils'
require 'backup'

# Optionを解析する
def parseOption(argv)
  props = Hash.new
  
  opt = OptionParser.new do |opt|
    opt.on('-d', '--debug') {
      |v| props[:debug] = v}
    opt.on('-t', '--test') {
      |v| props[:dry_run] = true}
  end
  
  if (opt.parse!(ARGV)) then
    return props
  else
    opt.usage()
    exit(1)
  end
end

# Loggerの初期化
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

#引数の解析
props = parseOption(ARGV);

#Logger準備
startupLogger(props);

#ログへの初期情報書き出し
$logger.info("================================");
$logger.info("       Html Sync #{Version}     ");
$logger.info("================================");

# 設定情報を読み出す。
cfgHash = HtmlSync::LoadConfig();

begin
  syncworker = HtmlSync::Syncworker.new(cfgHash[:appInf][:SRC_DIR],cfgHash[:appInf][:DST_DIR]);
  syncworker.backUp.genNum = cfgHash[:appInf][:BACKUP_GEN].to_i();  # バックアップ世代数をセット
  
  syncworker.dryrun() if (props[:dry_run]); # テストモードセット
  syncworker.backup(); # バックアップ実行

  if (File.exist?(File::expand_path(HtmlSync::CONF_FILE_NAME)))
    syncworker.setSyncFiles(cfgHash[:syncInf]).sync(); # 設定ファイルから読み込んで同期実行
  else
    syncworker.setSyncFiles(HtmlSync::SYNCFILES).sync(); #ソース内部のデフォルト値を利用して同期実行
  end
  
  $logger.info("Finished");
rescue Exception => ex
  $logger.error("Error Occurred.");
  $logger.error(ex.message);
end
