# Coding: UTF-8
$SourcePath = File.expand_path('../', __FILE__)
require $SourcePath + "/osu_api.rb"
require $SourcePath + "/osu_web.rb"
require 'json'
require 'fileutils'
require "date"
require 'thread'
require 'sqlite3'


###設定
api_key = ""
$user_name = ""
$password = ""
$mode = "3"
$thread_number = 3 #多すぎると回線速度的に逆に遅くなる
$since = "2013-02-14"
$param = "&m=#{$mode}&a=1" #since以外のパラメータを指定
$approved = [1]
$starts = 3　#指定以上の難易度
$diff_dize = 4 #キーの数
###ここまで


class Osu_downloader
  def initialize(osu_api_key)
    @osu_api = Osu_Application.new(osu_api_key)
    @osu_web = Osu_web.new($user_name, $password, osu_api_key, $mode)
    $cookie = "cookie:#{@osu_web.get_cookie}"
    @beatmaps = Queue.new
    @thread_list = Array.new($thread_number)
    @sum = 0
    @b_sum = 0
    dl_thread
    @path = $SourcePath + "/osz"
    FileUtils.mkdir_p(@path) unless FileTest.exist?(@path)
    @exist_c = "なし"
    @exist = []
    if File.exist?("#{$SourcePath}/exist")
      tmp = File.open("#{$SourcePath}/exist").read
      @exist = tmp.split("\r\n")
      @exist_c = "あり"
    end
  end
  
  def dl_thread
    Array.new($thread_number) do |i|
      @thread_list[i] = Thread.new do
        loop do
          beatmap = @beatmaps.pop
          download(beatmap)
        end
      end
    end
  end
  
  def download(map_id)
    `wget -O '#{$SourcePath}/osz/#{map_id}.osz' --header '#{$cookie}' https://osu.ppy.sh/d/#{map_id}`
    @sum += 1
    print "#{@beatmaps.size}..."
  end
  
  def get_beatmaps
    since = $since
    beatmapset_id = ""
    a_result = []
    loop do
      result = @osu_api.osu_api("/api/get_beatmaps", $param + "&since=" + since)
      return if a_result == result
      return unless result
      for i in 0..499 do
        puts i
        begin
          unless beatmapset_id == result[1][i]['beatmapset_id']
            beatmapset_id = result[1][i]['beatmapset_id']
            time = DateTime.parse(result[1][i]['last_update'])
            since = time.strftime("%Y-%m-%d")
            file = File.open("#{@SourcePath}/completion.txt", "w")
            file.write(since)
            file.close
            unless @exist.include?(beatmapset_id)
              if $approved.include?(result[1][i]['approved'].to_i) && $starts < result[1][i]['difficultyrating'].to_i && $diff_dize == result[1][i]['diff_size'].to_i
                @beatmaps.push(beatmapset_id)
                @b_sum += 1
              end
            end
          end
        rescue NoMethodError
          if $!.message == "undefined method `[]' for nil:NilClass"
            break
          else
            puts $!.message
          end
        end
      end
      a_result = result
    end
    puts "合計#{sum}個ダウンロード予定です。"
  end
  
  def main
    puts "#{$thread_number}スレッドにてダウンロードします。"
    puts "existファイル -> #{@exist_c}"
    puts "beatmapの取得とダウンロードは並列に行います。"
    get_beatmaps
    puts "beatmapを取得しました。全#{@b_sum}個"
    puts "ダウンロード待ちです......"
    print "残り..."
    loop do 
      break if @beatmaps.size == 0
    end
    puts "#{@sum}個ダウンロードしました。"
    puts "#{@path}に保存しました。"
  end
end
osu_downloader = Osu_downloader.new(api_key)
osu_downloader.main


