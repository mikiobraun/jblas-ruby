require 'test/unit'
require 'jblas'
require 'pp'

include JBLAS

class TestJblasAccess < Test::Unit::TestCase
  def setup
    # Looks like this:
    #
    #   1  4  7  10
    #   2  5  8  11
    #   3  6  9  12
    @x = DoubleMatrix.new(3, 4, [1,2,3,4,5,6,7,8,9,10,11,12].to_java(:double))
  end

  def test_linear_access
    assert_equal 12, @x.length
    assert_equal 1.0, @x[0]
    assert_equal 2.0, @x[1]
    assert_equal 12.0, @x[11]
  end

  def test_two_dim_access
    assert_equal 3, @x.rows
    assert_equal 4, @x.columns
    assert_equal [3,4], @x.dims
    assert_equal 1.0, @x[0, 0]
    assert_equal 4.0, @x[0, 1]
    assert_equal 6.0, @x[2, 1]
  end

  def test_rows_and_columns
    assert_equal mat[[1,4,7,10]], @x.getRow(0)
    assert_equal mat[[2,5,8,11]], @x.getRow(1)
    assert_equal mat[[3,6,9,12]], @x.getRow(2)

    assert_equal mat[[1,4,7,10]], @x.row(0)
    assert_equal mat[[2,5,8,11]], @x.row(1)
    assert_equal mat[[3,6,9,12]], @x.row(2)

    assert_equal mat[1,2,3], @x.column(0)
    assert_equal mat[4,5,6], @x.column(1)
    assert_equal mat[7,8,9], @x.column(2)
  end

  def test_swap_columns_and_rows
    @x.swap_columns 0, 1
    assert_equal mat[[4,1,7,10],[5,2,8,11],[6,3,9,12]], @x
    @x.swap_columns 0, 1
    @x.swap_rows 0, 1
    assert_equal mat[[2,5,8,11],[1,4,7,10],[3,6,9,12]], @x
    @x.swap_rows 0, 1
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

  def test_slices
    y = mat[0,1,2,3,4,5]
    assert_equal mat[1,3,5], y[[1, 3, 5]]

    y[[0, 1, 2, 3]] = mat[0, -1, -2, -3]
    assert_equal mat[0, -1, -2, -3, 4, 5], y
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
    assert_equal mat[[1, 2], [5, 6]], x.get_rows([0, 2].to_java :int)
    assert_equal mat[[1, 2], [1, 2]], x.get_rows([0, 0].to_java :int)
  end
end