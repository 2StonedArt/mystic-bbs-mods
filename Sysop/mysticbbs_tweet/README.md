# mysticbbs_tweet
Based on tweet.py by Alex Eames http://raspi.tv/?p=5908

Tweets users the log in and out of a Mystic BBS
Requires tweepy
  1. Put the two files in /Mystic/scripts/
  2. Add your Twitter Keys and tokens to both scripts
  2. Edit prelogin menu and add a command (DD) to run "python /mystic/scripts/tweet_BBS_login.py %U"
  3. Edit main menu and add command (DD) under logout option to run python /mystic/scripts/tweet_BBS_logout.py %U"
