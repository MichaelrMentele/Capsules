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

# Redirect to home page
get "/" do 
  erb :home, layout: :layout
end

# Render messaging page
get "/capsules" do 
  @capsules = session[:capsules]
  @sent_messages = session[:sent]
  erb :capsules, layout: :layout
end

#########
# POSTs #
#########

# Add a message to the user's collection
post "/capsules" do 
  session[:capsules] << params[:capsule_message]
  session[:success] = "Capsule added successfully"
  redirect "/capsules"
end

# !!!
# Send a text message
post "/send" do 
  # Update to remove from collection and into the 'sent' list
  capsule = random_capsule
  send_text(capsule)
  session[:success] = "Capsule sent successfully"

  message_sent!(capsule)

  redirect "/capsules"
end

###########
# Helpers #
###########
helpers do 
  
end

