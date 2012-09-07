# -*- coding: utf-8 -*-

require 'MeCab'

class Parser
  def initialize
    @tagger = MeCab::Tagger.new
  end

  def parseDir(dirname)
    parsed = []
    files = Dir::entries(dirname).collect do |f|
      [f, File::stat(dirname + f).mtime]
    end
    files.sort!{|a, b| a[1] <=> b[1]}.map!{|a| a[0]}
    files.each do |filename|
      next if File::directory?(dirname + filename)
      parsed += parseFile(dirname + filename)
    end
    parsed
  end

  def parseFile(filename)
    parsed = []
    open(filename).each do |line|
      parsed += parse(line)
    end
    parsed
  end

  def parse(sentence)
    parsed = []
    node = @tagger.parseToNode(sentence.gsub(' ', '　'))
    queue = []
    while node do
      fs = node.feature.split(',')
      if fs[0] != '助詞' and !['括弧始', '括弧終'].include?(fs[1]) and node.surface != ' ' and queue.size > 0
        parsed << flush(queue)
      end
      queue << node.surface.force_encoding('utf-8').gsub('　', ' ')
      node = node.next
      print '.'
    end
    parsed << flush(queue) if queue.size > 0
    puts 'done'

    parsed
  end

  def flush(queue)
    str = queue.join
    queue.clear
    str
  end
end

if __FILE__ == $0
  open(ARGV[1], 'w').write(Marshal.dump(Parser.new.parseDir(ARGV[0])))
end
