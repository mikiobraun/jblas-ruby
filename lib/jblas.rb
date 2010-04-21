# Java based matrix classes for ruby
#
# This file provides a module JBLAS which contains efficient matrix
# implementations based on java and BLAS/LAPACK implementations.
#
# For double precision computations, DoubleMatrix and DoubleVector are
# provided, for single precision computations, FloatMatrix and
# FloatVector.
#
# Basically, the classes provided are the actual java classes with
# syntactic sugar added (for example for arithmetic operations). This
# is integrates very nicely, however, not that the full list of
# methods is not available in rdoc.

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

require 'jblas/java'
require 'jblas/matrix_mixin'
require 'jblas/extensions'
require 'jblas/functions'
require 'jblas/arith'
require 'jblas/complex'

# The jblas module provides matrix classes and functions to
# comfortably work with the matrices.
#
# = Creation
#
#
# You create a matrix or vector explicitly by using the
# DoubleMatrix[], or FloatMatrix[] constructor. For example:
#
#   DoubleMatrix[[1,2,3],[4,5,6]]
#   => 1.0  2.0  3.0
#      4.0  5.0  6.0
#
#   DoubleMatrix[1,2,3]
#   => 1.0
#      2.0
#      3.0
#
# Since typing DoubleMatrix all the time is a bit cumbersome, jblas
# also provides the two shorthands mat and vec, which default to 
# the Double* counterparts.
#
# Apart from these constructors, there are few more functions which
# generate matrices or vectiors:
#
# * zeros(n), and zeros(n,m): vector or matrix of zeros.
# * ones - a vector or matrix of ones.
# * rand - a vector or matrix whose elements are drawn uniformly in [0,1]
# * randn - elemens are drawn from normal Gaussian distribution 
# * diag - return diagonal of a matrix or matrix with given diagonal
# * eye - identity matrix
# * x.hcat(y) - returns the horizontal concatenation of x and y
# * x.vcat(y) - returns the vertical concatenation of x and y
#
#
# = Accessing elements
#
# To access individual elements, use the [] or []= methods, or +get+, and +put+
# respectively.
#
# To access whole rows or columns, use a.column[i] or a.row[i].
#
#
# = Arithmetics
#
# Arithmetic is defined using the usual operators, that is
# 
# * (matrix-)multiplication: a * b
# * addition: a + b
# * subtraction: a - b
#
# Multiplication is the usual (linear algebra) multiplication. Apart
# from these shorthands, you can also call the explicit underlying
# methods. These also give you more control over the generation
# of temporary objects. The suffix "i" indicates that the computation
# is performed in-place on the left operand.
#
# * (matrix-)multiplication: a.mmul(b), a.mmuli(b)
# * elementwise multiplication: a.mul(b), a.muli(b)
# * addition: a.add(b), a.addi(b)
# * subtraction: a.sub(b), a.subi(b)
# * elementwise division: a.div(b), a.divi(b)
#
# Finally, a perculiar feature of jblas is that complex views of
# matrices cannot be used in in-place operations. The reason is that
# in-place operations like addition match to vector addition and BLAS
# vectors are not capable of representing sub-matrices. The solution
# is to call +compact+ before doing the addition.
#
# Some special functions exist for adding the same column vector to
# all columns of a matrix, or row vector to all rows:
#
# * m.add_column_vector(x) adds a column vector
# * m.add_row_vector(x) adds a row vector
#
#
#
# = Matrix and Vectors as Enumerables
#
# Both the matrices and vectors implement the Enumerable mixin. Matrices
# behave as if they are an array of the rows of a matrix, just as in
# construction. That is,
#
#   mat[[1,2,3],[4,5,6]].each do |row|
#     puts row
#   end
#   => [1,2,3]
#   [4,5,6]
#
# prints the two DoubleVectors which constitute the rows.
#
# = Functions
#
# JBLAS defines a large number of mathematical functions. You can
# either call these as a method on a matrix, vector, or even number,
# or in the usual notation as a function.
#
# * acos: arcus cosine
# * asin: arcus sine
# * atan: arcus tangens
# * cos: cosine
# * cosh: hyperbolic cosine
# * exp: exponential
# * log10: logarithm to base 10
# * log: natural logarithm
# * sin: sine
# * sinh: hyperbolic sine
# * sqrt: square root
# * tan: tangens
# * tanh: hyperbolic tangens
#
# By adding the suffix "i" or "!" to the method functions, you again perform the
# computation in-place. For example
#
#   exp(x)
#
# returns a copy of +x+, but
#
#   exp(x)
#   exp!(x)
# 
# do not.
#
#
# = Geometry
#
# Some functions to deal with geometric properties:
#
# * norm(x, type=2) computes the norm for type=1, 2, or :inf
# * x.dot(y) computes the scalar product
#
#
# = Linear Equations
#
# In order to solve the linear equation <tt>a * x = b</tt>, with +b+
# either being a matrix or a vector, call solve:
#
#   x = a.solve(b)
#
# or
#
#   solve(a, b)
#
#
# = Eigenproblems
#
# Compute the eigenvalue of a square matrix +a+ with
#
#   e = eig(a)
#
# Compute the eigenvectors as well with
#
#   u, d = eigv(a)
#
# eigv returns two matrices, the matrix +u+ whose columns are the
# eigenvectors, and the matrix +d+, whose diagonal contains the
# eigenvalues.
#
module JBLAS
  ######################################################################
  #
  # Matrices
  #
  ######################################################################
  
  class DoubleMatrix
    class <<self
      include MatrixClassMixin
    end

    include MatrixMixin

    alias get_columns_java get_columns
    def get_columns(indices)
      indices = indices.to_a.to_index_array
      get_columns_java(indices)
    end

    alias get_rows_java get_rows
    def get_rows(indices)
      indices = indices.to_a.to_index_array
      get_rows_java(indices)
    end
  end
 
  class FloatMatrix
    class <<self
      include MatrixClassMixin
    end
    include MatrixMixin
  end

  class ComplexDoubleMatrix
    class <<self
      include MatrixClassMixin
    end
    include MatrixMixin
  end

  class ComplexFloatMatrix
    class <<self
      include MatrixClassMixin
    end
    include MatrixMixin
  end

  class ComplexDouble
    include ComplexMixin
  end

  class ComplexFloat
    include ComplexMixin
  end
end