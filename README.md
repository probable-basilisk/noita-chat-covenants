# noita-chat-covenants
Noita Twitch integration experiment: allows Twitch chat to vote on persistent 'covenants' like "Circle of acid each time player takes damage" and "low gravity until 1000 gold is collected". The covenants are like templates of the form: (outcome) each time (condition), or (continuous effect) until (condition), and chat votes independently on both the outcome and the condition.
Super rough at the moment, not balanced at all, many combinations will probably crash noita.

## Installation

* Install the latest version of noita-ws-api.
* Clone this repo
* (in this repo's directory) `npm install`

## Running

* Make sure the ws-api mod is enabled
* (in this repo's directory) `node main_twitch.js your_twitch_channel_name`
* Start noita
