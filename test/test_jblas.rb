require 'test/unit'
require 'jblas'
require 'pp'

include JBLAS

def with(b, s)
  eval <<EOS, b
  puts "#{s} = \#\{#{s}\}"
EOS
end

class TestJBLAS < Test::Unit::TestCase
  def setup
    @x = DoubleMatrix.new(3, 3, [1,2,3,4,5,6,7,8,9].to_java(:double))
  end
  
  def test_to_ary
    assert_equal [[1,4,7],[2,5,8],[3,6,9]], @x.to_ary
    assert_equal [1,2,3], mat[1,2,3].to_ary
    assert_equal [1,2,3], mat[[1],[2],[3]].to_ary
    assert_equal [[1,2,3]], mat[[1,2,3]].to_ary
  end

  def test_reshape
    assert_equal mat[[1,2,3,4,5,6,7,8,9]], @x.reshape(1,9)
    assert_equal mat[1,2,3,4,5,6,7,8,9], @x.reshape(9,1)
    @x.reshape(3,3)
  end
  
  def test_map
    z = @x.map {|v| 2*v}
    assert_equal 2*@x, z
    assert_equal Java::OrgJblas::DoubleMatrix, z.class
  end
  
  def test_symmetric
    assert_equal false, @x.symmetric?
    assert_equal true, (@x + @x.t).symmetric?
  end
  
  def test_concatenation
    #puts "x.hcat x = #{x.hcat x}"
    #puts "x.vcat x = #{x.vcat x}"
  end
  
  def test_linspace
    #with binding, 'linspace(1, 10, 10)'
  end
end
