require "rake/clean"

BASE_URL = 'http://www.post.japanpost.jp/zipcode/dl/'
'kogaki/zip'
'jigyosyo/zip/'

SRC_DIR = '/tmp'

directory SRC_DIR

ZIPS = FileList["**/*.zip"]
CSVS = ZIPS.ext('csv')

CLEAN.include(ZIPS)
CLEAN.include(CSVS)

desc 'import postal codes from csv.'
task :import => ["#{SRC_DIR}/ken_all.csv", "#{SRC_DIR}/jigyosyo.csv"] do |t|
  require "fastercsv"
  require "kconv"

  t.prerequisites.each do |csv|
    type = (csv =~ /ken_all\.csv$/) ? 'kogaki' : 'jigyosyo'
    FasterCSV.foreach(csv) do |row|
      postal = Postal.new
      data = Postal.send "parse_#{type}", row
      data[:town] = '' if data[:town] == '以下に掲載がない場合'
      postal.attributes = data
      postal.save
      puts "UPDATE: #{postal.zipcode} #{postal.prefecture} #{postal.city} #{postal.town}"
    end
  end
end


desc 'drop database'
task :drop => "mi:drop" do
  puts "Database dropped."
end

rule ".csv" => ".zip" do |t|
  require "kconv"
  puts "Unzip:"
  puts " #{t.source}"
  puts " #{t.name}"

  sh "unzip -p #{t.source} > #{t.name}"
  csv_unicode = File.read(t.name).toutf8
  File.open(t.name, 'w').write csv_unicode
  #sh "nkf -w --overwrite #{t.name}"
end

rule ".zip" do |file|
  path = file.to_s.split(/\//).last

  type = path =~ /^ken_all/ ? 'kogaki' : 'jigyosyo'

  url = "#{BASE_URL}/#{type}/zip/#{path}"
  puts "Download:"
  puts " #{url}"
  puts " #{file}"

  sh "wget #{url} -O #{file}"
end

