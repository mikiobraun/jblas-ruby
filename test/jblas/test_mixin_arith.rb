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

class TestJblasMixinArith < Test::Unit::TestCase
  def setup
    @x = DoubleMatrix.new(3, 3, [1,2,3,4,5,6,7,8,9].to_java(:double))
  end

  def test_arithmetics
    assert_equal mat[[-1,-4,-7],[-2,-5,-8],[-3,-6,-9]], -@x
    assert_equal mat[[3,12,21],[6,15,24],[9,18,27]], 3*@x
    assert_equal mat[[1.0,0.25,1.0/7.0],[0.5,0.2,0.125],[1.0/3,1.0/6,1.0/9]], 1.0/@x
    assert_equal mat[[0.5,2,3.5],[1,2.5,4],[1.5,3,4.5]], @x/2
    assert_equal mat[[1,16,49],[4,25,64],[9,36,81]], @x ** 2
    assert_equal mat[[1,2,3],[4,5,6],[7,8,9]], @x.t
    assert_equal 285.0, (@x.dot @x)

    assert_equal mat[2,6,12], mat[1,2,3].mul(mat[2,3,4])
    assert_equal mat[2,3,4], mat[4,12,20] / mat[2,4,5]
  end

  def test_compare
    assert_equal mat[[1,0,0],[1,0,0],[0,0,0]], @x < 3
    assert_equal mat[[0,0,0],[1,0,0],[1,0,0]], ((@x <= 3) & (@x > 1))
    assert_equal mat[[1,1,1],[0,1,1],[0,1,1]], ((@x <= 3) & (@x > 1)).not
  end
end