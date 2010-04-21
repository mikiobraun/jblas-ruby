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
  # Mixin for general operations not fitting in any other category.
  #
  # Collected in MatrixMixin.
  module MatrixGeneralMixin
    # Transpose the matrix. You obtain a transposed view of the matrix.
    # Some operations are not possible on such views, for example
    # most in-place operations. For such, do a +compact+ first.
    def t; transpose; end

    # Get the size of the matrix as <tt>[rows, columns]</tt>
    def dims
      [rows, columns]
    end

    # Get the total number of elements. Synonymous to length.
    def size
      length
    end


    # Check whether the column index +i+ is valid.
    def check_column_index(i)
      unless 0 <= i and i < columns
        raise IndexError, "column index out of bounds"
      end
    end

    # Check whether the row index +i+ is valid.
    def check_row_index(i)
      unless 0 <= i and i < rows
        raise IndexError, "column index out of bounds"
      end
    end

    # Returns true if the matrix is square and symmetric.
    def symmetric?
      square? and self.sub(self.t).normmax < 1e-6
    end

    # Compute the inverse of self.
    def inv
      unless square?
        raise ArgumentError, 'Inverses can only be computed from square ' +
          'matrices. Use solve instead!'
      end
      self.solve(self.class.eye(rows))
    end

    # Solve the linear equation self * x = b.
    def solve(b)
      if symmetric?
        Solve.solve_symmetric(self, b)
      else
        Solve.solve(self, b)
      end
    end

    # Return a new matrix which consists of the _self_ and _y_ side by
    # side.  In general the hcat method should be used sparingly as it
    # creates a new matrix and copies everything on each use. You
    # should always ask yourself if an array of vectors or matrices
    # doesn't serve you better. That said, you _can_ do funny things
    # with +inject+. For example,
    #
    #   a = mat[1,2,3]
    #   [a, 2*a, 3*a].inject {|s,x| s = s.hcat(x)}
    #   => 1.0  2.0  3.0
    #      2.0  4.0  6.0
    #      3.0  6.0  9.0
    def hcat(y)
      unless self.dims[0] == y.dims[0]
        raise ArgumentError, "Matrices must have same number of rows"
      end
      DoubleMatrix.concat_horizontally(self, y)
    end

    # Return a new matrix which consists of the _self_ on top of _y_.
    # In general the hcat methods should be used sparingly. You
    # should always ask yourself if an array of vectors or matrices
    # doesn't serve you better. See also hcat.
    def vcat(y)
      unless self.dims[1] == y.dims[1]
        raise ArgumentError, "Matrices must have same number of columns"
      end
      DoubleMatrix.concat_vertically(self, y)
    end

    def e
      MatrixElementWiseProxy.new(self)
    end

    def d
      MatrixDotProxy.new(self)
    end

    def as_row
      return row_vector? ? self : t
    end

    def as_column
      return column_vector? ? self : t
    end

    def to_index_array
      self
    end

    def save_ascii(fn)
      o = open(fn, 'w')
      rows.times do |i|
        columns.times do |j|
          o.print get(i,j)
          o.print "\t" if j < columns - 1
        end
        o.puts
      end
      o.close
    end

    #def marshal_dump
    #  [rows, columns, data.to_a]
    #end

    #def mashal_load(d)
    #  puts "ouch"
    #  resize(d[0], d[1])
    #  d[2].each_with_index {|x,i| put(i, x)}
    #end
end
end