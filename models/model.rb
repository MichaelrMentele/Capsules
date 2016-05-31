require 'data_mapper'
require 'bcrypt'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/users.db")

class User
  include DataMapper::Resource

  property :id, Serial
  property :username, String, :required => true
  property :password, BCryptHash, :required => true
  property :phone, String
  property :email, String

  has n, :capsules
  has 1, :lover
end

class Capsule
  include DataMapper::Resource

  property :id, Serial
  property :message, Text, :required => true
  property :emoji, String

  belongs_to :user, :required => true
end

class Lover
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :required => true
  property :phone, String, :required => true

  belongs_to :user, :required => true
end

DataMapper.finalize.auto_upgrade!
