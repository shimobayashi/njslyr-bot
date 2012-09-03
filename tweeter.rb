# -*- coding: utf-8 -*-

require 'yaml'

require 'rubygems'
require 'twitter'

require_relative 'chainer'

class Array
  def choice
    self[rand(self.size)]
  end
end

puts 'start'

dir = File.dirname(File.expand_path(__FILE__))
account = YAML.load_file(dir + '/account.yaml')

Twitter.configure do |config|
  config.consumer_key = account['consumer_key']
  config.consumer_secret = account['consumer_secret']
  config.oauth_token = account['oauth_token']
  config.oauth_token_secret = account['oauth_token_secret']
end

dir = File.dirname(File.expand_path(__FILE__))
args = []
args << dir + '/faved.index'
args << dir + '/faved.start'
args << dir + '/faved.score'
args << dir + '/faved.posted'
c = Chainer.new(*args)
tweet = c.addToPosted(c.chainWithScoring)
puts tweet
Twitter.update(tweet)

puts 'finish'
