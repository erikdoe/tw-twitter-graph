tw-twitter-graph
================

A few Ruby scripts to calculate stats and graphs for a group of people on Twitter. 

I'm using [Gephi][] to render the graphs.

The scripts require two files to work:

### twitternames.txt

Screen names of the Twitter accounts, one per line

### downloads-auth.yml

A YAML file containing info to access the Twitter API, specifically:

*	consumer_key 
*	consumer_secret 
*	oauth_token
*	oauth\_token\_secret

You can get the keys by creating an app on the Twitter dev site [here][twitteraps]



  [Gephi]: http://gephi.org/
  [twitteraps]: https://dev.twitter.com/apps
	
