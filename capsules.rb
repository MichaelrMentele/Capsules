require "yaml"
require "twilio-ruby"

require "sinatra"
require "sinatra/reloader" if development?
require "tilt/erubis"

configure do
  enable :sessions
  set :session_secret, "secret"
end

before do
  session[:capsules] ||= []

  account_info = YAML.load_file("data/twilio_auth.yaml")
  @twilio_sid = account_info[:account_sid]
  @token = account_info[:auth_token]
end

get "/" do 
  redirect "/capsules"
end

get "/capsules" do 
  erb :capsules, layout: :layout
end

get "/send" do 
  #require 'pry'; binding.pry;
  send_text(random_message)
  redirect "/capsules"
end

post "/capsules" do 
  session[:capsules] << params[:capsule_message]
  redirect "/capsules"
end

helpers do 
  def random_message
    # error assertion if no message provided
    session[:capsules].sample
  end

  def send_text(message)
    client = Twilio::REST::Client.new(
      @twilio_sid,
      @token
    )

    client.messages.create(
      to: "12066184282",
      from: "14255288374",
      body: message
    )
  end
end