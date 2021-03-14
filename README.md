# README

SlackPlayground is a rails app for Slack.


# Preparation

* Install/Use ruby 3.0.0
* Install/Use node 15.10.0

Other(later or earlier) versions may work.

* Run bundle
* Run yarn

* Install `foreman`. (gem install foreman)

# Setup slack app

* Create slack app https://slack.com/apps
  * Set proper oauth permissions
  * Set proper oauth callback url.  
* Set APP_ID and APP_SECRET to ENV['SLACK_APP_KEY'] and ENV['SLACK_APP_SECRET'] using `.env`.
