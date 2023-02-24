#!/usr/bin/env ruby
# gem install watir && gem install telegram-bot && get install dotenv && ruby burgerbot.rb
require 'watir'
require 'telegram/bot'
require 'dotenv'
Dotenv.load





def log (message) puts "  #{message}" end
def success (message) puts "+ #{message}" end
def fail (message) puts "- #{message}" end
def notify (message)
  success message.upcase
  system 'osascript -e \'Display notification "Bürgerbot" with title "%s"\'' % message
rescue StandardError => e
end

bot_id =  ENV["TELEGRAM_BOT_ID"]
chat_id = ENV["TELEGRAM_CHAT_ID"]

if !bot_id || !chat_id
  fail 'Missing bot ID/ chat_id'
end
  
Telegram.bots_config = {
  default: ENV["TELEGRAM_BOT_ID"],
}
Telegram.bot.get_updates


def triggerFound (url)
  notify 'An appointment is available.'
  log 'Enter y to keep searching or anything else to quit.'
  chat_id = ENV["TELEGRAM_CHAT_ID"]
  if(!chat_id)
    fail 'missing chat_id'
    return
  end
  Telegram.bot.send_message(chat_id: chat_id, text: 'Found an appointment! '+ url)
  notify 'An appointment is available.'
  notify 'An appointment is available.'
  notify 'An appointment is available.'
  notify 'An appointment is available.'
end


def appointmentAvailable? (b)
  url = 'https://service.berlin.de/terminvereinbarung/termin/tag.php?termin=1&anliegen[]=120686&dienstleisterlist=329745,122231,122280,330436,122243,327348,327346,122297,327286&herkunft=http%3A%2F%2Fservice.berlin.de%2Fdienstleistung%2F120686%2F'
  puts '-'*80
  log 'Trying again'

  b.goto url
  log 'Page loaded'
  foundCss = 'td.buchbar'
  link = b.element css: foundCss
  if link.exists?
    link.click
    triggerFound url
    return gets.chomp.downcase != 'y'
  else
    link_next = b.element css: 'th.next > a'
    link_next.click 
    # second page
    link = b.element css: foundCss
    log 'second page'
    if link.exists?
      triggerFound url
      return gets.chomp.downcase != 'y'
    else 
      fail 'No luck this time.'
      return false
    end
  end

rescue StandardError => e
  fail 'Error encountered.'
  puts e.inspect
  return false
end

b = Watir::Browser.new

until appointmentAvailable? b
  log 'asd'
  log 'Sleeping. 2 min'
  time1 = Time.new
  puts "Current Time : " + time1.inspect
  sleep 120
end
