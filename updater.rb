# -*- coding: utf-8 -*-

require_relative 'crawler'
require_relative 'parser'
require_relative 'indexer'
require_relative 'scorer'
require_relative 'starter'

class Updater
  def update(txtDir, parsedFilename, indexFilename, scoreFilename, startFilename)
    Crawler.new.run(txtDir)
    f = open(parsedFilename, 'w'); f.write(Marshal.dump(Parser.new.parseDir(txtDir))); f.close
    f = open(indexFilename, 'w'); f.write(Marshal.dump(Indexer.new(3).indexingFile(parsedFilename))); f.close
    f = open(scoreFilename, 'w'); f.write(Marshal.dump(Scorer.new.calcFile(parsedFilename))); f.close
    f = open(startFilename, 'w'); f.write(Marshal.dump(Starter.new.calcFile(indexFilename))); f.close
  end
end

if __FILE__ == $0
  dir = File.dirname(File.expand_path(__FILE__))
  args = []
  args << dir + '/faved/'
  args << dir + '/faved.posted'
  args << dir + '/faved.index'
  args << dir + '/faved.score'
  args << dir + '/faved.start'
  Updater.new.update(*args)
end
