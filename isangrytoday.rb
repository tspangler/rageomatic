require 'rubygems'
require 'sinatra'
require 'haml'
require 'sass'
require 'open-uri'
require 'json'

set :haml, :format => :html5
set :logging, true
mime_type :ttf, 'application/octet-stream'

get '/' do
  haml :index
end

get '/check' do
  @username = params[:username]  

  # Set up an empty hash for the angriest tweet of them all
  @angriest_tweet = {:name => '', :score => 0, :text => ''}
  @angriest_tweet[:name] = @username

  begin
    # Fetch the timeline
    @timeline = fetch_and_parse_timeline(@username)
    @timeline.each do |tweet|
      angriness_factor = calculate_angriness_factor(tweet['text'])

      @angriness_total = 0
      angriness_factor.each_value {|value| @angriness_total += value}
    
      if @angriness_total > @angriest_tweet[:score]
        @angriest_tweet[:score] = @angriness_total
        @angriest_tweet[:text] = tweet['text']
      end
    end    

  rescue OpenURI::HTTPError
    @timeout = "Couldn't find Twitter user #{@username}!"

  rescue Timeout::Error
    @timeout = 'Could not fetch timeline for ' + @username + '.'
  end
  
  @angriest_tweet.to_json
end

get '/css/screen.css' do
  scss :screen
end

def fetch_and_parse_timeline(username)
    timeline = open('http://api.twitter.com/1/statuses/user_timeline.json?screen_name=' + username + '&trim_user=true&count=200').read

    # Return parsed timeline
    JSON.parse(timeline)
end

def calculate_angriness_factor(str)
  @CURSE_WORDS = Regexp.new(/fuck|shit|bitch/i)

  # First, determine the percentage of letters in the string that are capitalized
  capital_factor = (((str.scan(/[A-Z]/).count).quo(str.length)) * 100).round

  # Now figure out what percentage of the words are naughty
  curse_factor = ((str.scan(@CURSE_WORDS).count).quo(str.scan(/\w/).count)*100).round

  # And finally, count the exclamation points
  exclamation_factor = (str.count('!').quo(str.length) * 100).round
  
  {
    :capital => capital_factor,
    :curse_factor => curse_factor,
    :exclamation_factor => exclamation_factor
  }
end
