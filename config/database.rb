require "uri"

uri = URI.parse(ENV['MONGOHQ_URL']) if ENV['MONGOHQ_URL']

# Connection.new takes host, port
host = case Padrino.env 
  when :development then 'localhost'
  when :production  then uri.host
  when :test        then 'localhost'
end

port = case Padrino.env
  when :development then Mongo::Connection::DEFAULT_PORT
  when :production  then uri.port
  when :tset        then Mongo::Connection::DEFAULT_PORT
end

database_name = case Padrino.env
  when :development then 'postal2_development'
  when :production  then 'postal2_production'
  when :test        then 'postal2_test'
end

con = case Padrino.env
  when :development then Mongo::Connection.new(host, port).db(database_name)
  when :production  then Mongo::Connection.new(host, port).db(database_name).authenticate(uri.user, uri.password)
  when :test        then Mongo::Connection.new(host, port).db(database_name)
end

Mongoid.database = con

# You can also configure Mongoid this way
# Mongoid.configure do |config|
#   name = @settings["database"]
#   host = @settings["host"]
#   config.master = Mongo::Connection.new.db(name)
#   config.slaves = [
#     Mongo::Connection.new(host, @settings["slave_one"]["port"], :slave_ok => true).db(name),
#     Mongo::Connection.new(host, @settings["slave_two"]["port"], :slave_ok => true).db(name)
#   ]
# end
#
# More installation and setup notes are on http://mongoid.org/docs/
