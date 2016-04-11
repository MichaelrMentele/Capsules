import os
from flask import Flask, render_template
import lovebot

app = Flask(__name__)

@app.route("/")
def main():
    lover = lovebot.LoveBot()
    agent = "LoveBot"
    tag = "-Michael"
    lover.send_messages(agent, love_messages, tag)
    return render_template('index.html')

msg1 = "My name is MichaelLoveBot. I love you. Come with me if you want to live.",
msg2 = "Yes. This is a robot controlled by Michael. I might send you messages randomly from time to time."
msg3 = "Michael says he wants a kiss."


love_messages = {
	0 : "I want to cuddle you",
	1 : "You are gorgeous.",
	2 : "My master Michael says, \"I love you\"",
	3 : "How'd you get so pretty?",
	4 : "I don't know how I lived without you... Oh, wait I didn't... Because I'm a program... of love!",
	5 : "You are so pretty... and witty and Briiiiiiii! \n PS Michael forced me to say that... I usually make way better puns.",
	6 : "I want to make love to you all day LONG... But I'm just a computer program and Michael would delete me if I did...",
	7 : "Have I mentioned you're pretty?",
    8 : "xoxo"
}

if __name__ == "__main__":
    app.run(host=os.getenv('IP', '0.0.0.0'), port=int(os.getenv('PORT',8080)))
    
    

    