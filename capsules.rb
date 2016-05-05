require "yaml"
require "twilio-ruby"
require "sinatra"
require "sinatra/reloader" if development?
require "tilt/erubis"

before do
  @account_info = YAML.load_file("data/twilio_auth.yaml")
  @twilio_sid = @account_info[:account_sid]
  @token = @account_info[:auth_token]
end

get "/" do 
  @message = "I love you..."
  send_message(@message)
end

helpers do 
  def random_message

  end

  def send_message(message)
    client = Twilio::REST::Client.new(
      @twilio_sid,
      @token
    )

    client.messages.create(
      to: "12066184282",
      from: "14255288374",
      body: message
    )

    puts "Message sent"
  end
end