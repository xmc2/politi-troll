# Testing twitter

from tweepy import process_or_store
me = api.get_user('mattcol3')
print(me.screen_name)
print(me.followers_count)
for friend in me.friends():
   print(friend.screen_name)

hrc = api.get_user('hillaryclinton')
print(hrc.screen_name)
print(hrc.followers_count)
for friend in hrc.friends():
   print(friend.screen_name)
hrc.user_timeline("hillaryclinton")
