# -*- coding: utf-8 -*-

require 'kconv'

require 'rubygems'
require 'mechanize'

class Crawler
  def initialize
    @agent = Mechanize.new
  end

  def run(outDir)
    `rm -f #{outDir}*.txt`

    for page in 1..10
      begin
        @agent.get "http://favotter.net/user/NJSLYR?mode=new&threshold=5&page=#{page}"
        @agent.page.search('div[@class="info"]').each do |t|
          t.to_s =~ /(http:\/\/twitter\.com\/NJSLYR\/status\/(\d+))/
          puts $2, $1
          fetch($2, $1, outDir)
        end
      rescue
        p $!
        retry
      end
    end
    puts 'done'

    for page in 1..10
      begin
        @agent.get "http://favotter.net/user/NJSLYR&mode=best&page=#{page}"
        @agent.page.search('div[@class="info"]').each do |t|
          t.to_s =~ /(http:\/\/twitter\.com\/NJSLYR\/status\/(\d+))/
          fetch($2, $1, outDir)
        end
      rescue
        p $!
        retry
      end
    end
    puts 'done'
  end

  def fetch(id, url, outDir)
    begin
      @agent.get url
      @agent.page.search('//p[contains(@class, "tweet-text")]').each do |t|
        tweet = t.inner_text.toutf8
        next if ['(', '（', '◇', '□',  '【', '■', '◆'].include?(tweet.split(//u)[0])
        tweet =~ /^(.+?)([\s|　]?\d+)?$/
        tweet = $1.strip
        puts id, tweet
        open("#{outDir}#{id}.txt", 'w').write(tweet)
        print '.'
        break
      end
    rescue
      p $!
      retry
    end
  end
end

if __FILE__ == $0
  Crawler.new.run(*ARGV)
end
