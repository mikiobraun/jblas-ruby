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
require 'jblas/errors'
require 'jblas/mixin_complex_matrix'

# The jblas module provides matrix classes and functions to
# comfortably work with the matrices.
#
# = Overview
#
# JBLAS defines the following six classes:
#
# * DoubleMatrix - double precision real matrix
# * FloatMatrix - single precision real matrix
# * ComplexDoubleMatrix - double precision complex matrix
# * ComplexFloatMatrix - single precision complex matrix
# * ComplexDouble - double precision complex number
# * ComplexFloat - single precision complex number
#
# These classes have the usual arithmetic operations defined as well as coercion
# to make them work as seamlessly as possible with the norm built-in Ruby
# numerical types.
#
# Technically, jblas-ruby is organized in a number of mixins which are included
# in the Java objects to add syntactic sugar and make the objects play well
# with Ruby. Links to these mixins are included in each section.
#
# = Creation
#
# <em>See also JBLAS::MatrixClassMixin, mat</em>
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
# Since typing DoubleMatrix all the time is a bit cumbersome, jblas also
# provides the mat function which is a short-hand for DoubleMatrix[...]:
#
#   mat[1,2,3]
#   => 1.0
#      2.0
#      3.0
#
# Apart from these constructors, there are few more functions which
# generate matrices or vectors:
#
# * zeros(n), and zeros(n,m): vector or matrix of zeros.
# * ones(...) - a vector or matrix of ones.
# * rand(...) - a vector or matrix whose elements are drawn uniformly in [0,1]
# * randn(...) - elemens are drawn from normal Gaussian distribution
# * diag(x) - return diagonal of a matrix or matrix with given diagonal
# * eye(n) - identity matrix
# * x.hcat(y) - returns the horizontal concatenation of x and y
# * x.vcat(y) - returns the vertical concatenation of x and y
#
# hcat and vcat also exist as methods which take an arbitrary number of arguments
# and returns the horizontal or vertical concatenation of its arguments.
#
# = Accessing elements
#
# <em>See also JBLAS::MatrixAccessMixin.</em>
#
# To access individual elements, use the [] or []= methods, or +get+, and +put+
# respectively.
#
# Rows and columns can be accessed with get_row, put_row and get_column, put_column.
#
# You can also often use ranges or enumerables with [] and []=, for example
#
#   x[0..2, [1,2,3]]
#
# = Arithmetics
#
# <em>See also JBLAS::MatrixAccessMixin.</em>
#
# Arithmetic is defined using the usual operators, that is
# 
# * (matrix-)multiplication: a * b
# * addition: a + b
# * subtraction: a - b
#
# Multiplication is the usual (linear algebra) multiplication.
# 
# There exist also non-operator versions (which are the original Java functions)
# These also give you more control over the generation
# of temporary objects. The suffix "!" or "i" indicates that the computation
# is performed in-place on the left operand.
#
# * (matrix-)multiplication: a.mmul(b), a.mmul!(b)
# * elementwise multiplication: a.mul(b), a.mul!(b)
# * addition: a.add(b), a.add!(b)
# * subtraction: a.sub(b), a.sub!(b)
# * elementwise division: a.div(b), a.div!(b)
#
# Some special functions exist for adding the same column vector to
# all columns of a matrix, or row vector to all rows:
#
# * m.add_column_vector(x) adds a column vector
# * m.add_row_vector(x) adds a row vector
#
# = Matrix and Vectors as Enumerables
#
# <em>See also JBLAS::MatrixEnumMixin.</em>
#
# Both the matrices and vectors implement the Enumerable mixin. Matrices behave
# as if they are a linear array of their elements (going down rows first). If
# you want to iterate over rows or columns, use the rows_to_a or columns_to_a methods,
# as well as each_row and each_column.
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
# = Singular value decomposition
#
# Compute the singular value decomposition of an (arbitrarily shaped)
# matrix +a+ with
#
#    u, s, v = svd(a)
#
# The columns of +u+ and +v+ will contain the singular vectors, and +s+ is
# a vector containing the singular values.
#
# You can also compute a sparse SVD with svd(a, true) (meaning that +u+
# and +v+ are not square but have the minimal rectangular size necessary).
#
# Finally, svdv(a) computes only the singular values of +a+.

module JBLAS
  ######################################################################
  #
  # Matrices
  #
  ######################################################################

  # Matrix for stroing float values.
  #
  # This matrix is essentially org.jblas.DoubleMatrix with all the syntactic
  # sugar defined in the MatrixClassMixin and MatrixMixin mix-ins. See those
  # modules for further information, and the JBLAS module for an overview.
  class DoubleMatrix
    class <<self
      include MatrixClassMixin
    end

    include MatrixMixin
  end
 
  # Matrix for storing float values.
  #
  # This matrix is essentially org.jblas.FloatMatrix with all the syntactic
  # sugar defined in the MatrixClassMixin and MatrixMixin mix-ins. See those
  # modules for further information, and the JBLAS module for an overview.
  class FloatMatrix
    class <<self
      include MatrixClassMixin
    end
    include MatrixMixin
  end

  # Matrix for storing complex double values.
  #
  # This matrix is essentially org.jblas.ComplexDoubleMatrix with all the syntactic
  # sugar defined in the MatrixClassMixin and MatrixMixin mix-ins. See those
  # modules for further information, and the JBLAS module for an overview.
  class ComplexDoubleMatrix
    class <<self
      include MatrixClassMixin
    end
    include MatrixMixin
    include ComplexMatrixMixin
  end

  # Matrix for storing complex float values.
  #
  # This matrix is essentially org.jblas.ComplexFloatMatrix with all the syntactic
  # sugar defined in the MatrixClassMixin and MatrixMixin mix-ins. See those
  # modules for further information, and the JBLAS module for an overview.
  class ComplexFloatMatrix
    class <<self
      include MatrixClassMixin
    end
    include MatrixMixin
    include ComplexMatrixMixin
  end

  # Double precision complex number.
  #
  # This class is essentially org.jblas.ComplexDouble with the syntactic sugar
  # defined in the module ComplexMixin.
  class ComplexDouble
    include ComplexMixin
  end

  # Single precision complex number.
  #
  # This class is essentially org.jblas.ComplexFloat with the syntactic sugar
  # defined in the module ComplexMixin.
  class ComplexFloat
    include ComplexMixin
  end

  I = ComplexDouble::I
end