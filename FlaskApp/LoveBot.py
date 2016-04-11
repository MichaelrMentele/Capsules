from twilio.rest import TwilioRestClient
import random
import time


class LoveBot(object):
    #your account Sid and Auth token from twilio.com/user/account
    account_sid = "AC0016f4c55afaf79b77ec86e2bf32ec19"
    auth_token = "36077868d84cb02d517eb5d02199c08b"

    def send_messages(self, agent="Bot", love_messages={0:"I'm...speechless."}, tag=None):
        client = TwilioRestClient(self.account_sid, self.auth_token)

        while True:
        	key=int(random.random() * len(love_messages))
        	message = client.messages.create(
        		body=agent + ':' + love_messages[key] + tag,
        		to="12536704733",
        		from_="14255288374")
        	message = client.messages.create(
        		body=agent + ':' + love_messages[key] + tag,
        		to="12066184282",
        		from_="14255288374")
        	time.sleep(1000 + random.random() * 3600)




