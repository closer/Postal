require "rake/clean"

BASE_URL = 'http://www.post.japanpost.jp/zipcode/dl/kogaki/zip'

SRC_DIR = '/tmp'

directory SRC_DIR

ZIPS = FileList["**/*.zip"]
CSVS = ZIPS.ext('csv')

CLEAN.include(ZIPS)
CLEAN.include(CSVS)

desc 'import postal codes from csv.'
task :import => [SRC_DIR, "#{SRC_DIR}/ken_all.csv"] do |t|
  require "fastercsv"
  require "kconv"

  FasterCSV.foreach(t.prerequisites[1]) do |row|
    postal = Postal.new
    data = Postal.parse(row)
    data[:town] = '' if data[:town] == '以下に掲載がない場合'
    postal.attributes = data
    postal.save
    puts "UPDATE: #{postal.zipcode} #{postal.prefecture} #{postal.city} #{postal.town}"
  end
end


desc 'drop database'
task :drop do
  Mongoid.master.collections.
    select{|c| c.name != 'system.indexes' }.each &:drop
  puts "Database dropped."
end

rule ".csv" => ".zip" do |t|
  puts "Unzip:"
  puts " #{t.source}"
  puts " #{t.name}"

  sh "unzip -p #{t.source} > #{t.name}"
  sh "nkf -w --overwrite #{t.name}"
end

rule ".zip" do |file|
  path = file.to_s.split(/\//).last

  url = "#{BASE_URL}/#{path}"
  puts "Download:"
  puts " #{url}"
  puts " #{file}"

  sh "wget #{url} -O #{file}"
end

