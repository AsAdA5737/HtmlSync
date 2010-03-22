#!/usr/bin/ruby

# for mac, install modules
# rubyzip
#   -> sudo port install rb-zip
# rubygems
#   -> sudo port install rb-rubygems
# 

$LOAD_PATH << File.join(File.dirname(__FILE__),"lib");

require "rubygems"
require 'optparse'
require 'logger'
require 'htmlparser'
require 'config'
require 'utility'
require 'syncworker'
require 'ZipFileUtils'

Version="0.1.0";

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

if (props[:dry_run])
  puts "TBD. Test mode here"  
end

# puts HtmlSync::SYNCFILES["kankyo.html"];

syncworker = HtmlSync::Syncworker.new(HtmlSync::SRC_DIR,HtmlSync::DST_DIR);
syncworker.backup(); # ファイルをバックアップ
syncworker.setSyncFiles(HtmlSync::SYNCFILES).sync(); # 同期実行

$logger.info("Finished");