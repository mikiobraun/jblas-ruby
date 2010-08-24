require 'test/unit'
require 'jblas'
require 'pp'

include JBLAS

class TestJblasMixinGeneral < Test::Unit::TestCase
  def test_transpose
    x = mat[[1,2,3],[4,5,6]]

    xt = x.t

    assert_equal 3, xt.rows
    assert_equal 2, xt.columns

    assert_in_delta 0.0, norm(mat[[1,4],[2,5],[3,6]] - xt, :inf), 1e-9
  end

  def test_size
    x = mat[[1,2,3],[4,5,6]]

    assert_equal 2, x.rows
    assert_equal 3, x.columns
    assert_equal [2,3], x.dims
    assert_equal 6, x.size
    assert_equal 6, x.length
  end

  def test_hcat
    x = mat[1,2]
    y = mat[[3,4],[5,6]]

    assert_equal mat[[1,3,4],[2,5,6]], x.hcat(y)

    assert_raise ArgumentError do
      mat[1,2,3].hcat mat[4,5]
    end
  end

  def test_vcat
    x = mat[[1,2]]
    y = mat[[3,4],[5,6]]

    assert_equal mat[[1,2],[3,4],[5,6]], x.vcat(y)

    assert_raise ArgumentError do
      mat[[1,2,3]].vcat(mat[[4,5]])
    end
  end

  def test_e
    x = mat[1,2,3]
    y = mat[4,5,6]
    assert_equal x.mul(y), x .e* y
  end

  def test_d
    x = mat[1,2,3]
    y = mat[4,5,6]
    assert_equal x.dot(y), x .d* y
  end

  def test_as_row_or_column_vector
    c = mat[1,2,3]
    r = mat[[1,2,3]]
    m = mat[[1,2,3],[4,5,6]]

    assert c.column_vector?
    assert c.as_row.row_vector?
    assert r.row_vector?
    assert r.as_column.column_vector?
    
    # No change for full matrix
    assert !m.column_vector?
    assert !m.row_vector?
    assert_equal m, m.as_row
    assert_equal m, m.as_column
  end

  def test_scalar
    s = mat[1]
    m = mat[[1,2]]

    assert s.scalar?
    assert !m.scalar?
    assert_equal 1.0, s.scalar
    assert_equal 1.0, m.scalar
  end
end
