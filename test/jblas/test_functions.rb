require 'test/unit'
require 'jblas'
require 'pp'

include JBLAS

class TestJblasFunctions < Test::Unit::TestCase
  def setup
    @x = DoubleMatrix.new(3, 3, [1,2,3,4,5,6,7,8,9].to_java(:double))
  end

  def test_diag
    assert_equal mat[[1, 0, 0], [0, 2, 0], [0, 0, 3]], diag(mat[1, 2, 3])
    assert_equal mat[1, 2, 3], diag(mat[[1, 0, 0], [0, 2, 0], [0, 0, 3]])
  end

  def test_functions
    #puts "sin(x) = #{sin(x)}"
    #with binding, 'cos(0)'
    assert_equal mat[2 ** 3, 4 ** 3], pow!(mat[2, 4], 3)
    assert_equal mat[Math.sin(1), Math.sin(3)], sin!(mat[1,3])
  end

  def test_solve
    x = rand(3, 3)
    y = rand(3)

    z = x.solve(y)

    assert_in_delta 0.0, norm(y - x * z, :inf), 1e-3
  end

  def test_trace
    assert_equal 15, trace(mat[[1,2,3],[4,5,6],[7,8,9]])
  end

  def test_eig
    a = mat[[1, 2, 3], [2, 1, 2], [3, 2, 1]]

    u, l = eigv a
    assert_in_delta 0.0, norm(a - u * l * u.t, :inf), 1e-3

    l2 = eig a    
    assert_in_delta 0.0, norm(l - diag(l2), :inf), 1e-3
  end

  def test_sum
    assert_equal 6, mat[1,2,3].sum
    assert_equal mat[[6],[15]], mat[[1,2,3],[4,5,6]].row_sums
  end

  def test_inv
    x = mat[[1, 2, 0], [1, 2, 1], [0, 1, 2]]
    xi = x.inv
    assert_equal eye(3), x * xi

    x = DoubleMatrix.eye(10)
    assert_equal x.inv, x
  end

  def test_lu
    a = mat[[1,2,3],[4,5,6],[7,8,9]]
    lu = org.jblas.Decompose.lu(a)

    assert_in_delta 0, norm(a - lu.p * lu.l * lu.u, :inf), 1e-3

    a = mat[[1,2,3,4],[5,6,7,8]]
    lu = org.jblas.Decompose.lu(a)

    assert_in_delta 0, norm(a - lu.p * lu.l * lu.u, :inf), 1e-3

    a = (mat[[1,2,3,4],[5,6,7,8]]).t
    lu = org.jblas.Decompose.lu(a)

    assert_in_delta 0, norm(a - lu.p * lu.l * lu.u, :inf), 1e-3
  end

  def test_cholesky
    a = mat[[4, 2, 1], [2, 4, 2], [1, 2, 4]]
    u = org.jblas.Decompose.cholesky(a)
    assert_in_delta 0, norm(a - u.t * u), 1e-3

    assert_raise NativeException do
      # actually, org.jblas.exceptions.LapackPositivityException
      a = mat[[2, 3], [3, 2]]
      org.jblas.Decompose.cholesky(a)
    end
  end

  def test_lup
    x = mat[[1,2,3],[4,5,6],[7,8,9]]

    l, u, p = lup(x)

    assert_in_delta 0.0, norm(x - p*l*u, :inf), 1e-3
  end

  def test_det
    x = mat[[1,2,3],[4,5,6],[7,8,4]]
    assert_in_delta 15.0, det(x), 1e-3
  end
end