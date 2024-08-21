#!/usr/bin/env python
# tweet.py by Alex Eames http://raspi.tv/?p=5908
# Modified to tweet BBS connections

import tweepy, sys, datetime

# Consumer keys and access tokens, used for OAuth
consumer_key = 'consumer_key'
consumer_secret = 'consumer_secret'
access_token = 'access_token'
access_token_secret = 'access_token_secret'

# OAuth process, using the keys and tokens
auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)

# Creation of the actual interface, using authentication
api = tweepy.API(auth)
time = datetime.datetime.now()
timenow = '{:%H:%M:%S}'.format(time)

# Enter tweet text below
if len(sys.argv) >= 2:
    tweet_text = sys.argv[1] + " [Enter some text here] @ " + str(timenow)

else:
    tweet_text = "Still messing about with tweepy and twitter API. :)"

if len(tweet_text) <= 280:
    api.update_status(status=tweet_text)
else:
    tweet_text = "UserName too long!"
