require 'test/unit'
require 'jblas'

include JBLAS

class TestDecompose < Test::Unit::TestCase
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
end
