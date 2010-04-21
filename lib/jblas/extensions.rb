# Define extensions to Object, Array, Numeric and Range to play well with
# matrices.
#
# Main additions are: Object#to_mat, and Numeric#columns, Numeric#rows, and so on.

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

# Extensions to Ruby's Object class
class Object
  # convert object to a matrix through to_mat
  def to_matrix
    to_mat
  end
end

# Extensions to Ruby's Array class
class Array
  # Convert array to matrix.
  def to_mat
    JBLAS::DoubleMatrix[*self]
  end

  # Convert array to matrix string representation
  def to_matlab_string
    '[' + map{|e| e.to_s}.join(', ') + ']'
  end

  # Convert an array to an array useable for indexing.
  def to_index_array
    to_java :int
  end
end

# Extensions to Ruby's Range class
class Range
  # Convert to matrix object.
  def to_mat
    self.to_a.to_mat
  end
end

# Extensions to Ruby's Numeric class
class Numeric
  # Convert to matlab. Just returns the object itself. Other
  # methods are added below to make a Numeric object look like
  # a matrix.
  def to_mat
    self # JBLAS::DoubleMatrix[self]
  end

  # Convert to matrix.
  def to_matrix
    JBLAS::DoubleMatrix[self]
  end

  # Returns number of columns (= 1).
  def columns
    1
  end

  # Returns number of rows (= 1).
  def rows
    1
  end

  # Element access (always returns the Numeric object itself)
  def [](*args)
    self
  end

  # Is a scalar? (always true)
  def scalar?
    true
  end

  # Transpose (is the same object).
  def t
    self
  end

  # Length of the Numeric object (= 1).
  def length
    1
  end

  def i
    ComplexDouble.new(0, self)
  end
end