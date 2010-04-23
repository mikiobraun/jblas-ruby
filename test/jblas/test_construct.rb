require 'test/unit'
require 'jblas'
require 'pp'

include JBLAS

class TestJblasArith < Test::Unit::TestCase
  def setup
    @x = DoubleMatrix.new(3, 3, [1,2,3,4,5,6,7,8,9].to_java(:double))
  end

 def test_constructor
    assert_equal [[1,4,7],[2,5,8],[3,6,9]], @x.to_array2.to_ary
    assert_equal [1,2,3,4,5,6,7,8,9], @x.to_array.to_ary
    assert_equal [[1],[2],[3]], mat[1,2,3].to_array2.to_ary
    assert_equal [[1,2,3],[4,5,6],[7,8,9]], mat[[1,2,3],[4,5,6],[7,8,9]].to_array2.to_ary
    assert_equal [3, 3], @x.dims
  end
end