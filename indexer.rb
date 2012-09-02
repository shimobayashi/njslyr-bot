# -*- coding: utf-8 -*-

class Indexer
  def initialize(depth)
    @depth = depth
  end

  def indexingFile(filename)
    indexing(Marshal.load(open(filename).read))
  end

  def indexing(parsed)
    index = {}
    keys = []
    parsed.each do |str|
      if keys.size == @depth
        index[keys] = [] unless index.has_key?(keys)
        index[keys] << str
        keys = keys.dup
      end

      keys.shift if keys.size == @depth
      keys << str

      print '.'
    end
    puts 'done'

    index
  end
end

if __FILE__ == $0
  open(ARGV[2], 'w').write(Marshal.dump(Indexer.new(ARGV[1].to_i).indexingFile(ARGV[0])))
end
