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

def with(b, s)
  eval <<EOS, b
  puts "#{s} = \#\{#{s}\}"
EOS
end

class TestJBLAS < Test::Unit::TestCase
  def setup
    @x = DoubleMatrix.new(3, 3, [1,2,3,4,5,6,7,8,9].to_java(:double))
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
