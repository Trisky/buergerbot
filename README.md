# Bürgerbot

Checks for free appointments in Berlin germany's citizens office and notifies via telegram.


This bot also checks the next month, so it will find appointments in the future as well. 

## How to run:

1. Add `TELEGRAM_CHAT_ID=yyy` and `TELEGRAM_BOT_ID=xxx` to a `.env` file.

2. Install gems with
`gem install watir && gem install telegram-bot`

3. Run with `ruby burgerbot.rb`

Note: bot pauses when it finds something.


## Based on:

https://gist.github.com/pbock/3ab260f3862c350e6b5f

https://gist.github.com/xuio/297e16b84d700314241393e8f3aa42f3
