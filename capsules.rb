require "yaml"
require "twilio-ruby"

require "sinatra"
require "sinatra/reloader" if development?
require "tilt/erubis"

require "./models/model"

configure do
  enable :sessions
  set :session_secret, "secret"
end

before do
  session[:capsules] ||= []
  session[:sent] ||= []

  # Load Twilio account auth info
  account_info = YAML.load_file("data/twilio_auth.yaml")
  @twilio_sid = account_info[:account_sid]
  @token = account_info[:auth_token]
end

###########
# Methods #
###########

# !!!
def random_capsule
  # error assertion if no message in session
  session[:capsules].sample
end

# Send text via Twilio API
def send_text(message)
  client = Twilio::REST::Client.new(
    @twilio_sid,
    @token
  )

  # !!! This needs to be dynamic
  client.messages.create(
    to: "12066184282",
    from: "14255288374",
    body: message
  )
end

def message_sent!(capsule)
  session[:sent] << session[:capsules].delete(capsule)
end

def logged_in?
  !!session[:username]
end

def please_login
  session[:error] = "You are not logged in. Please login or register."
  redirect "/login"
end

########
# GETs #
########

# !!! Needs styling
# Render Splash
get "/splash" do
   erb :splash, layout: :layout_no_auth
end  

# !!! Needs styling
# Render Login page
get "/login" do 
  erb :login, layout: :layout_no_auth
end

# !!! Needs styling
# Render Registration page
get "/register" do 
  @users = User.all
  erb :register, layout: :layout_no_auth
end 

### Requires User ###

# Render home page
get "/" do 
  if logged_in?
    # !!! How are capsules being stored now?
    username = session[:username]
    user = User.first(:username => username)
    @capsules = user.capsules.all

    @sent_messages = session[:sent]
    erb :home, layout: :layout
  else
    please_login
  end
end

# !!!
# Render Setting page
get "/settings" do 
  if logged_in?
    erb :settings, layout: :layout
  else
    please_login
  end
end

###########
# TESTING #
###########

get "/debug" do
  username = session[:username]
  user = User.first(:username => username)
  @capsules = user.capsules.all
  erb :debug, layout: :layout
end

#########
# POSTs #
#########

# Register a new user
post "/register" do
  newbie = User.new 
  newbie.username = params[:username]
  newbie.password = params[:password]
  newbie.save

  session[:username] = newbie.username 
  session[:success] = "You are logged in!" # !!! Should display username
  redirect "/" 
end

# Login a registered user
post "/login" do
  @users = User.all
  username_attempt = params[:username]
  password_attempt = params[:password]

  @users.each do |user|
    if user.username == username_attempt and user.password == password_attempt
      session[:username] = user.username
      session[:success] = "Welcome #{user.username}!"
      redirect "/"
    end
  end
  session[:error] = "Sorry, wrong info bro."
  redirect "/login"
end

# Add a message to the user's collection
post "/capsules" do 

  require 'pry'; binding.pry;

  # get current user
  username = session[:username]
  user = User.first(:username => username)

  # add capsule to user
  message = params[:capsule_message]
  user.capsules.create(:message => message)

  session[:success] = "Capsule added successfully"
  redirect "/register"
end

# !!!
# FOR DEBUGGING/TESTING ONLY
# Send a text message
post "/send" do 
  # Update to remove from collection and into the 'sent' list
  capsule = random_capsule
  send_text(capsule)
  session[:success] = "Capsule sent successfully"

  message_sent!(capsule)

  redirect "/"
end

###########
# Helpers #
###########
helpers do 
  
end

