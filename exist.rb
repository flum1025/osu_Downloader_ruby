# Coding: UTF-8

SourcePath = File.expand_path('../', __FILE__)
if File.exist?("#{SourcePath}/exist")
  File.unlink("#{SourcePath}/exist")
end
dirs = Dir.glob("#{SourcePath}/Songs/*")
file = File.open("#{SourcePath}/exist", "a")
sum = 0
dirs.each {|dir|
  if dir.match(/Songs\/(\d+)/)
    file.write("#{$1}\n")
    sum += 1
  end
}
file.close
puts "合計#{sum}譜面取得しました。"