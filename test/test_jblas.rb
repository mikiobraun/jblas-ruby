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
  
  def test_constructor
    assert_equal [[1,4,7],[2,5,8],[3,6,9]], @x.to_array2.to_ary
    assert_equal [1,2,3,4,5,6,7,8,9], @x.to_array.to_ary
    assert_equal [[1],[2],[3]], mat[1,2,3].to_array2.to_ary
    assert_equal [[1,2,3],[4,5,6],[7,8,9]], mat[[1,2,3],[4,5,6],[7,8,9]].to_array2.to_ary
    assert_equal [3, 3], @x.dims
  end
  
  def test_to_ary
    assert_equal [[1,4,7],[2,5,8],[3,6,9]], @x.to_ary
    assert_equal [1,2,3], mat[1,2,3].to_ary
    assert_equal [1,2,3], mat[[1],[2],[3]].to_ary
    assert_equal [[1,2,3]], mat[[1,2,3]].to_ary
  end
  
  def test_arithmetics
    assert_equal [[-1,-4,-7],[-2,-5,-8],[-3,-6,-9]], -@x
    assert_equal [[3,12,21],[6,15,24],[9,18,27]], 3*@x
    assert_equal [[1.0,0.25,1.0/7.0],[0.5,0.2,0.125],[1.0/3,1.0/6,1.0/9]], 1.0/@x
    assert_equal [[0.5,2,3.5],[1,2.5,4],[1.5,3,4.5]], @x/2
    assert_equal [[1,16,49],[4,25,64],[9,36,81]], @x ** 2
    assert_equal [[1,2,3],[4,5,6],[7,8,9]], @x.t
    assert_equal 285.0, (@x.dot @x)

    assert_equal [2,6,12], mat[1,2,3].mul(mat[2,3,4])
    assert_equal [2,3,4], mat[4,12,20] / mat[2,4,5]
  end

  def test_reshape
    assert_equal [[1,2,3,4,5,6,7,8,9]], @x.reshape(1,9)
    assert_equal [1,2,3,4,5,6,7,8,9], @x.reshape(9,1)
    @x.reshape(3,3)
  end
  
  def test_compare
    assert_equal [[1,0,0],[1,0,0],[0,0,0]], @x < 3
    assert_equal [[0,0,0],[1,0,0],[1,0,0]], ((@x <= 3) & (@x > 1))
    assert_equal [[1,1,1],[0,1,1],[0,1,1]], ((@x <= 3) & (@x > 1)).not
    assert_equal Array, @x.select {|z| z <= 5}.class
  end
  
  def test_rows_and_columns
    assert_equal [[1,4,7]], @x.getRow(0)
    assert_equal [[2,5,8]], @x.getRow(1)
    assert_equal [[3,6,9]], @x.getRow(2)

    assert_equal [[1,4,7]], @x.row(0)
    assert_equal [[2,5,8]], @x.row(1)
    assert_equal [[3,6,9]], @x.row(2)

    assert_equal [1,2,3], @x.column(0)
    assert_equal [4,5,6], @x.column(1)
    assert_equal [7,8,9], @x.column(2)

    @x.swap_columns 0, 1    
    assert_equal [[4,1,7],[5,2,8],[6,3,9]], @x
    @x.swap_columns 0, 1
    @x.swap_rows 0, 1
    assert_equal [[2,5,8],[1,4,7],[3,6,9]], @x
    @x.swap_rows 0, 1
    rs = [ [[1,4,7]], [[2,5,8]], [[3,6,9]] ]
    c = 0
    @x.each_row do |r|
      assert_equal rs[c], r
      c += 1
    end
    cs = [[1,2,3],[4,5,6],[7,8,9]]
    i = 0
    @x.each_column do |c|
      assert_equal cs[i], c
      i += 1
    end
  end
  
  def test_map
    z = @x.map {|v| 2*v}
    assert_equal 2*@x, z
    assert_equal Java::OrgJblasLa::DoubleMatrix, z.class
  end
  
  def test_symmetric
    assert_equal false, @x.symmetric?
    assert_equal true, (@x + @x.t).symmetric?
  end
  
  def test_concatenation
    #puts "x.hcat x = #{x.hcat x}"
    #puts "x.vcat x = #{x.vcat x}"
  end
  
  def test_diag
    #d = diag([1,2,3])
    #puts "d = diag[1,2,3] = #{d}"
    #puts "d.diag = #{d.diag}"
    #puts "diag d = #{diag d}"
  end

  def test_functions
    #puts "sin(x) = #{sin(x)}"
    #with binding, 'cos(0)'
end

  def test_slices
    #puts "x[[0,2,4,6,8]] = #{x[[0,2,4,6,8]]}"
    #puts "x[[0,2],[0,1]] = #{x[[0,2],  [0,1]]}"
    #puts "x[0...5] = #{x[0...5]}"
    #puts "(x < 5).find_indices = #{(x < 5).find_indices.to_a.inspect}"
    #i = (x < 5).find_indices
    #puts "x.get(i) = #{x.get(i)}"
    #puts "x[i] = #{x[i]}"

    #xx = x.dup
    #x[(x < 5).find_indices] = mat[2,1,2,1]
    #puts "x[(x < 5).find_indices] = mat[2,1,2,1,2] => x = #{x}" 
    #x = xx

    #xx = x.dup
    #x[x < 5] = -1
    #puts "x[x < 5] = -1 => x = #{x}"
    #x = xx

    x = mat[[1,2],[3,4],[5,6]]
    assert_equal [[1, 2], [5, 6]], x.get_rows([0, 2].to_java :int)
    assert_equal [[1, 2], [1, 2]], x.get_rows([0, 0].to_java :int)
  end

  def test_sovle
    #a = mat[[1,2,0],[2,1,2],[0,2,1]]
    #b = mat[[1,2,3],[4,5,6],[7,8,9]]
    #ab = mat[[9,12,15],[20,25,30],[15,18,21]]
    #with binding, 'a'
    #with binding, 'b'
    #with binding, 'ab'
    #with binding, 'a.solve(ab)'
  end
  
  def test_trace
    #with binding, 'trace x'
  end
  
  def test_eig
    #with binding, 'eig a'
  
    #with binding, 'u, v = eigv a; [u, v]'
  end
  
  def test_linspace
    #with binding, 'linspace(1, 10, 10)'
  end
  
  def test_sum
    assert_equal 6, mat[1,2,3].sum
    assert_equal mat[[6],[15]], mat[[1,2,3],[4,5,6]].row_sums
  end
end
