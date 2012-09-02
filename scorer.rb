# -*- coding: utf-8 -*-

class Scorer
  def initialize
  end

  def calcFile(filename)
    calc(Marshal.load(open(filename).read))
  end

  def calc(parsed)
    count = 0
    scores = {}
    parsed.each do |str|
      if count < parsed.size * 0.1
        scores[str] = 50 unless scores.has_key?(str)
      else
        scores[str] = 0 unless scores.has_key?(str)
      end
      scores[str] += 1
      print '.'
      count += 1
    end
    puts 'done'

    scores
  end
end

if __FILE__ == $0
  open(ARGV[1], 'w').write(Marshal.dump(Scorer.new.calcFile(ARGV[0])))
end
