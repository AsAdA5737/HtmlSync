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

Version="1.0.0";

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
syncworker.backup(); # ファイルをバックアップ
syncworker.dryrun() if (props[:dry_run]); # テストモードセット

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
