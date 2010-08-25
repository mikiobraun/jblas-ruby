# Mixin for class methods of the matrix classes. Defines JBLAS::MatrixClassMixin.

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

module JBLAS
  # Mixin for the Matrix classes. These basically add the [] construction
  # method (such that you can say DoubleMatrix[1,2,3]
  module MatrixClassMixin
    # Create a new matrix. For example, you can say DoubleMatrix[1,2,3].
    # 
    # See also from_array.
    def [](*data)
      from_array data
    end

    # Create a new matrix. There are two ways to use this function
    #
    # <b>pass an array</b>::
    #   Constructs a column vector. For example: DoubleMatrix.from_array 1, 2, 3
    # <b>pass an array of arrays</b>::
    #   Constructs a matrix, inner arrays are rows. For
    #   example: DoubleMatrix.from_array [[1,2,3],[4,5,6]]
    #
    # See also [], JBLAS#mat
    def from_array(data)
      n = data.length
      if data.reject{|l| Numeric === l}.size == 0
        a = self.new(n, 1)
        (0...data.length).each do |i|
          a[i, 0] = data[i]
        end
        return a
      else
        begin
          lengths = data.collect{|v| v.length}
        rescue
          raise "All columns must be arrays"
        end
        raise "All columns must have equal length!" if lengths.min < lengths.max
        a = self.new(n, lengths.max)
        for i in 0...n
          for j in 0...lengths.max
            a[i,j] = data[i][j]
          end
        end
        return a
      end
    end
  end
end