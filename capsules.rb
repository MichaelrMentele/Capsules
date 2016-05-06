require "yaml"
require "twilio-ruby"

require "sinatra"
require "sinatra/reloader" if development?
require "tilt/erubis"

before do
  @messages = YAML.load_file("data/messages.yaml")

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
  send_text(random_message)
end

post "/capsules" do 

end

helpers do 
  def random_message
    # error assertion if no message provided
    random_key = @messages.keys.sample
    @messages[random_key]
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