
desc 'test performance'
task :perform do
  1000.times do |n|
    puts n
    fork do
      Postal.where(:zipcode => /^#{n}/).limit(10).entries.to_json
    end
    sleep 0.01
  end
end

