require 'data_mapper'
require 'bcrypt'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/users.db")

class User
  include DataMapper::Resource

  property :id, Serial
  property :username, String, :required => true
  property :password, BCryptHash, :required => true

  has n, :capsules
end

class Capsule
  include DataMapper::Resource

  property :id, Serial
  property :message, Text, :required => true
  property :emoji, String

  belongs_to :user, :required => true
end

DataMapper.finalize.auto_upgrade!
