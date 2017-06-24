require 'sinatra'
require_relative 'tweet.rb'

get '/' do
  'under construction'
end

get '/send_tweet' do
   Tweet.new.send_tweet
end