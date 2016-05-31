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

  # !!! NEEDS ENCRPYTION ADD TO MODELS AND DB
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
  # !!! Needs to remove from capsules and append to 'sent'
  user = find_user
  user.capsules.sample.message
end

# Send text via Twilio API
def send_text(message)
  user = find_user

  client = Twilio::REST::Client.new(
    @twilio_sid,
    @token
  )

  # !!! This needs to be dynamic
  client.messages.create(
    to: user.lovers[0].phone,
    from: "14255288374",
    body: message
  )

  # !!! FOR TESTING PURPOSES!!!
  client.messages.create(
    to: "2066184282",
    from: "14255288374",
    body: message
  )
end

def find_user
  username = session[:username]
  User.first(:username => username)
end

# !!! NEEDS TO BE INCLUDED IN MODEL
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

#########
# POSTs #
#########

# Register a new user
post "/register" do
  user = User.new 
  user.username = params[:username]
  user.password = params[:password]
  user.save

  user.lovers.create(:name => params[:lover_name], :phone => params[:lover_phone])
  user.save

  session[:username] = user.username 
  session[:success] = "You are logged in #{user.username}!" # !!! Should display username
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
  user = find_user

  # add capsule to user
  message = params[:capsule_message]
  user.capsules.create(:message => message)
  user.save

  session[:success] = "Capsule added successfully"
  redirect "/"
end


# Update user settings
post "/update_user_info/:property" do
  user = find_user

  # Update User info
  property = params[:property].to_sym

  if property == :lover
    user.lovers[0].update(:phone => params[:lover_phone],
                      :name  => params[:lover_name])
  else
    user.update(property => params[property])
  end

  redirect "/settings"
end

###########
# Helpers #
###########
helpers do 
  
end

###########
# TESTING #
###########

get "/debug" do
  username = session[:username]
  @user = User.first(:username => username)
  @capsules = @user.capsules.all
  erb :debug, layout: :layout
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
