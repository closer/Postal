# Connection.new takes host, port

host, port, database_name = case Padrino.env 
  when :development 
    ['localhost',
    Mongo::Connection::DEFAULT_PORT,
    'postal2_development']
  when :production
    require "uri"
    if ENV['MONGOHQ_URL']
      uri = URI.parse(ENV['MONGOHQ_URL'])
      [uri.host,
      uri.port,
      uri.path.gsub(/^\//, '')]
    end
  when :test
    ['localhost',
    Mongo::Connection::DEFAULT_PORT,
    'postal2_test']
end

con = Mongo::Connection.new(host, port).db(database_name)

con.authenticate(uri.user, uri.password) if Padrino.env == :production

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
