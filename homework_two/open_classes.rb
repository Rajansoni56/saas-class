# Helper method to test everything
def assert
  raise "Assertion failed" unless yield
end

class Numeric
  @@currencies = {'yen' => 0.013, 'euro' => 1.292, 'rupee' => 0.019, 'dollar' => 1}

  def in(target)
    if target.to_s !~ /dollar/
      self / 1.send(target)
    else
      self.send(target)
    end
  end

  def method_missing(method_id)
    singular_currency = method_id.to_s.gsub( /s$/, '')
    if @@currencies.has_key?(singular_currency)
      self * @@currencies[singular_currency]
    else
      super
    end
  end
end

class String
  def palindrome?
    string = self # Do not work *on* the string
    string.gsub!(/(\W|\b)+/i, "").downcase!
    string == string.reverse
  end
end

module Enumerable
  def palindrome?
    test_arr = self.map{ |x| x }
    test_arr == test_arr.reverse
  end
end

class TestPal
  include Enumerable

  def initialize
    @numbers = [1,2,1]
  end

  def each
    @numbers.each { |x| yield(x) }
  end
end


assert { "anita lava la tina".palindrome? }
assert { !"foo".palindrome? }

assert { [1,2,3,2,1].palindrome? }
assert { ![1,2,2,3,2,1].palindrome? }
assert { !{a: 3, b: 4}.palindrome? }
assert { TestPal.new.palindrome? }

assert { 5.euro.in(:euro) == 5 }
assert { 5.euro.in(:dollars) == 5.euro }
assert { 5.dollars.in(:euro) < 5 }
