# -*- coding: utf-8 -*-

class Array
  def choice
    self[rand(self.size)]
  end
end

class Hash
  def choice
    keys.choice
  end
end

class Chainer
  def initialize(indexFilename, startFilename, scoreFilename, postedFilename)
    @index = Marshal.load(open(indexFilename).read)
    @start = Marshal.load(open(startFilename).read)
    @score = Marshal.load(open(scoreFilename).read)
    @postedFilename = postedFilename
    begin
      @posted = File.exist?(postedFilename) ? Marshal.load(open(postedFilename).read) : []
    rescue
      p $!
      @posted = []
    end
  end

  def chainWithScoring(sample = 100)
    tmp = []
    sample.times do
      res = chain
      redo unless validate(res[:out])
      tmp << res
    end

    tmp.sort! {|a, b| b[:score] <=> a[:score]}
    tmp[0][:out]
  end

  def chain
    out = ''
    score = 0
    key = @start.choice.dup
    while !((out.split(//u).size > 50) and (['。', '！', '？', '」'].include?(out.split(//u)[-1])))
      out += key[0]
      score += @score[key[0]] if @score.include?(key[0])

      break unless @index[key]
      key << @index[key].choice
      key.shift
      break if key[0] == ''
    end

    {:out => out, :score => score}
  end

  def validate(str)
    return false if @posted.include?(str)

    flag = true
    brackets = [
      [['「', 0], ['」', 0]],
      [['(' , 0], [')' , 0]],
      [['（', 0], ['）', 0]],
      [['【', 0], ['】', 0]],
      [['『', 0], ['』', 0]],
    ]
    str.split(//u).each do |c|
      brackets.each do |b|
        b[0][1] += 1 if b[0][0] == c
        b[1][1] += 1 if b[1][0] == c

        flag = false if b[1][1] > b[0][1]
      end
      break unless flag
    end
    brackets.each do |b|
      flag = false if b[0][1] != b[1][1]
    end
    return false unless flag

    flag &= !str.include?('#')
    flag &= !str.include?('http://')
    flag &= !str[1..-1].include?('@')
    flag &= str.split(//u).size < 140
    flag
  end

  def addToPosted(str)
    @posted << str
    open(@postedFilename, 'w').write(Marshal.dump(@posted))
    str
  end
end

if __FILE__ == $0
  dir = File.dirname(File.expand_path(__FILE__))
  args = []
  args << dir + '/faved.index'
  args << dir + '/faved.start'
  args << dir + '/faved.score'
  args << dir + '/faved.posted'
  c = Chainer.new(*args)
  puts c.addToPosted(c.chainWithScoring)
end
