# doctocheck

This script check for any change in the doctolib.fr availabilities of a specific agenda (ie. doctor / medical entity) for a specific motive.

This is a very quick & dirty draft and shouldn't be taken seriously. Please don't use it for anything serious.

## Setup

1. Retrieve the needed ids on doctolib and put them in `config/doctolib.yml` (following the structure of `config/doctolib.example.yml`)
2. Set your `config/schedule.rb` based on your needs & the available rake tasks (following the structure of `config/schedule.rb`)
3. Retrieve your Discord bot token (following [this guide](https://www.writebots.com/discord-bot-token/)) (only read & mention everyone rights are needed) and put the bot token in your `/.env` (following the structure of `/.env`).
4. Retrieve the Discord channel id (in the Discord app got to Settings > Advanced > Check the "developer mode", then right click on the channel you want the bot to work in & click "Copy channel id") and put it in your `/.env` (following the structure of `/.env`).
5. Run `whenever --update-crontab` to update your crontab and you're good to go.
