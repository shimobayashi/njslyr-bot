# -*- coding: utf-8 -*-

class Starter
  def initialize
  end

  def calcFile(filename)
    calc(Marshal.load(open(filename).read))
  end

  def calc(index)
    starts = []
    index.each do |keys, v|
      if (keys[0] == '' and keys[1] != '')
        starts << keys
      end
      print '.'
    end
    puts 'done'

    starts
  end
end

if __FILE__ == $0
  open(ARGV[1], 'w').write(Marshal.dump(Starter.new.calcFile(ARGV[0])))
end
