# Copyright (c) 2009-2010, Mikio L. Braun and contributors
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#
#     * Redistributions in binary form must reproduce the above
#       copyright notice, this list of conditions and the following
#       disclaimer in the documentation and/or other materials provided
#       with the distribution.
#
#     * Neither the name of the Technische Universität Berlin nor the
#       names of its contributors may be used to endorse or promote
#       products derived from this software without specific prior
#       written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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

  def test_svd
    x = mat[[1,3,5],[2,4,6],[3,2,1]]

    u, s, v = svd(x)

    assert_in_delta 0.0, norm(x - u*diag(s)*v.t, :inf), 1e-9
  end
end