require 'data_mapper'
require 'bcrypt'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/../data/users.db")

class User
  include DataMapper::Resource

  property :id, Serial
  property :username, String, :required => true
  property :password, BCryptHash, :required => true
end

DataMapper.finalize.auto_upgrade!