require "sinatra"
require "sinatra/reloader" if development?
require "tilt/erubis"

before do
end

get "/" do 
  @message = "I love you..."
end

helpers do 
  def random_message

  end
end