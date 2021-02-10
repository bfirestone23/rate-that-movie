ENV['RACK_ENV'] ||= "development"

require 'bundler/setup'
Bundler.require(:default, ENV['RACK_ENV'])

configure :development do
    set :database, 'sqlite3:db/development.sqlite'
end

configure :production do

end

# ActiveRecord::Base.establish_connection(
#     :adapter => "sqlite3",
#     :database => "db/development.sqlite"
# )
  
require_all 'app'