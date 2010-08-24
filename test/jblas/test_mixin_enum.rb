require 'test/unit'
require 'jblas'
require 'pp'

include JBLAS

class TestJblasMixinEnum < Test::Unit::TestCase
  def setup
    # Looks like this:
    #
    #   1  4  7  10
    #   2  5  8  11
    #   3  6  9  12
    @x = DoubleMatrix.new(3, 4, [1,2,3,4,5,6,7,8,9,10,11,12].to_java(:double))
  end

  def test_each_row
    rs = [ mat[[1,4,7,10]], mat[[2,5,8,11]], mat[[3,6,9,12]] ]
    c = 0
    @x.each_row do |r|
      assert_equal rs[c], r
      c += 1
    end
  end

  def test_each_column
    cs = [mat[1,2,3],mat[4,5,6],mat[7,8,9],mat[10,11,12]]
    i = 0
    @x.each_column do |c|
      assert_equal cs[i], c
      i += 1
    end
  end
end
