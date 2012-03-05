# Helper method to test everything
def assert
  raise "Assertion failed" unless yield
end

class CartesianProduct
  include Enumerable

  attr_accessor :product

  def initialize(a, b)
    @product = [ ]
    a.each do |x|
      b.each{ |y| @product << [x, y] }
    end unless b.empty?
  end

  # Returns the cartesian product AxB
  def each
    product.each { |x| yield x}
  end
end

# Assert Empty cartesian products
assert { CartesianProduct.new([], []).each{|x| x }.empty? }
assert { CartesianProduct.new([], [1, 2, 4]).each{|x| x }.empty? }
assert { CartesianProduct.new([1, 3, 4], []).each{|x| x }.empty? }
