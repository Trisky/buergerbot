#!/usr/bin/env ruby
# gem install watir && gem install telegram-bot && gem install dotenv && ruby burgerbot.rb
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
  Telegram.bot.send_message(chat_id: chat_id, text: 'Found appointments! '+ url)
  notify 'An appointment is available.'
  notify 'An appointment is available.'
  notify 'An appointment is available.'
  notify 'An appointment is available.'
end

def openFirstTermin b
  link = b.element css: "td.frei > a"
  if link
    link.click
  else
    fail 'no link to click'
  end 
end

def appointmentAvailable? (b)
  # anmeldung berlinwide:
  url = 'https://service.berlin.de/terminvereinbarung/termin/tag.php?termin=1&anliegen[]=120686&dienstleisterlist=122210,122217,327316,122219,327312,122227,327314,122231,327346,122243,327348,122254,122252,329742,122260,329745,122262,329748,122271,327278,122273,327274,122277,327276,330436,122280,327294,122282,327290,122284,327292,122291,327270,122285,327266,122286,327264,122296,327268,150230,329760,122297,327286,122294,327284,122312,329763,122314,329775,122304,327330,122311,327334,122309,327332,317869,122281,327352,122279,329772,122283,122276,327324,122274,327326,122267,329766,122246,327318,122251,327320,122257,327322,122208,327298,122226,327300&herkunft=http%3A%2F%2Fservice.berlin.de%2Fdienstleistung%2F120686%2F'
  
  # anmeldung mitte, kberg, pberg
  #url = 'https://service.berlin.de/terminvereinbarung/termin/tag.php?termin=1&anliegen[]=120686&dienstleisterlist=329745,122231,122280,330436,122243,327348,327346,122297,327286&herkunft=http%3A%2F%2Fservice.berlin.de%2Fdienstleistung%2F120686%2F'
  puts '-'*80
  log 'Trying again'

  b.goto url
  log 'Page loaded'
  foundCss = 'td.buchbar'
  link = b.element css: foundCss
  if link.exists?
    #link.click --> uncomment these 2 lines if you want the first date available
    #openFirstTermin b
    triggerFound url
    sleep 60
    return false #gets.chomp.downcase != 'y'
  else
    link_next = b.element css: 'th.next > a'
    link_next.click 
    second page
    link = b.element css: foundCss
    log 'Looking into second page'
    if link.exists?
     triggerFound url
     sleep 200
     return false #gets.chomp.downcase != 'y'
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
  log 'Sleeping. 3 min'
  time1 = Time.new
  puts "Current Time : " + time1.inspect
  sleep 180
end
