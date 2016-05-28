# Capsules
A simple text message batcher to automatically sprinkle a little bit of love on someone's day.

## Who
Capsules is for couples who are working professionals or are simply obsessed with productivity.

## What
Capsules is a cute, wuvy (yes we called it 'wuvy') Sinatra app that uses the Twilio API to send text messages to a designated 'lover.'

## How
1. Clone the directory:
`git clone https://github.com/MichaelrMentele/Capsules.git`
2. Modify `data/twilio.yml` with your Twilio API credentials
3. Deploy locally by navigating to cloned directory and running:
`bundle install`
`ruby capsules.rb`
Alternatively you can deploy to Heroku. Assuming you have the toolbelt installed, simply create a new Heroku app and push the project.

### You can use an active version of the app [HERE](https://capsules.herokuapp.com/)