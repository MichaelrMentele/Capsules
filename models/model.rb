require 'data_mapper'
require 'bcrypt'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/users.db")

class User
  include DataMapper::Resource

  property :id, Serial
  property :username, String, :required => true
  property :password, BCryptHash, :required => true
  property :phone, String
  property :email, String

  has n, :capsules
  has n, :lovers
end

class Capsule
  include DataMapper::Resource

  property :id, Serial
  property :message, Text, :required => true
  property :sent, Boolean, :default => false
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
