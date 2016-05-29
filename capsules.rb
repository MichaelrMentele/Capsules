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

########
# GETs #
########

# !!!
# Render Splash
get "/splash" do
   erb :splash, layout: :layout # !!! Use layout 2
end  

# !!!
# Render Login page
get "/login" do 
  erb :login, layout: :layout # !!! Use layout 2
end

# !!!
# Render Registration page
get "/register" do 
  @users = User.all
  erb :register, layout: :layout # !!! Use layout 2
end 

# Render home page
get "/" do 
  @capsules = session[:capsules]
  erb :home, layout: :layout
end

# Render sent messages page
get "/sent" do 
  @sent_messages = session[:sent]
  erb :sent, layout: :layout
end

# !!!
# Render Setting page
get "/settings" do 
  erb :settings, layout: :layout
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

  session[:success] = "You are logged in!" # !!! Should display username
  redirect "/" 
end

# Add a message to the user's collection
post "/capsules" do 
  session[:capsules] << params[:capsule_message]
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

