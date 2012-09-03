# -*- coding: utf-8 -*-

require 'kconv'

require 'rubygems'
require 'mechanize'

class Crawler
  def initialize
    @agent = Mechanize.new
  end

  def run(outDir)
    #`rm -f #{outDir}*.txt`

    for page in 1..5
      @agent.get "http://favotter.net/user/NJSLYR?mode=new&threshold=5&page=#{page}"
      @agent.page.search('div[@class="info"]').each do |t|
        t.to_s =~ /(http:\/\/twitter\.com\/NJSLYR\/status\/(\d+))/
        begin
          fetch($2, $1, outDir)
        rescue
          p $!
          next
        end
      end
    end

    for page in 1..5
      begin
        @agent.get "http://favotter.net/user/NJSLYR&mode=best&page=#{page}"
        @agent.page.search('div[@class="info"]').each do |t|
          t.to_s =~ /(http:\/\/twitter\.com\/NJSLYR\/status\/(\d+))/
          begin
            fetch($2, $1, outDir)
          rescue
            p $!
            next
          end
        end
      end
    end
  end

  def fetch(id, url, outDir)
    @agent.get url
    @agent.page.search('//span[@class="entry-content"]').each do |t|
      tweet = t.inner_text.toutf8
      next if ['(', '（', '◇', '□',  '【', '■', '◆'].include?(tweet.split(//u)[0])
      tweet =~ /^(.+?)([\s|　]?\d+)?$/
      tweet = $1
      open("#{outDir}#{id}.txt", 'w').write(tweet)
    end
  end
end

if __FILE__ == $0
  Crawler.new.run(*ARGV)
end
