# Functions within JBLAS, for example, sin, cos, and so on.

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
  module_function

  ######################################################################
  #
  # Helper methods
  #
  ######################################################################

  # Check whether matrix is square. Raises ArgumentError if it isn't.
  def check_matrix_square(m)
    unless m.square?
      raise ArgumentError, "Matrix is not square."
    end
  end

  ######################################################################
  #
  # Module Functions
  #
  ######################################################################


  MatrixFactory = {
    :double => DoubleMatrix,
    :float => FloatMatrix
  }

  # Construct a matrix. Use it like this:
  #
  #   mat[1,2,3] -> constructs a column vector
  #   mat[[1,2,3],[4,5,6]] -> construct a rectangular matrix
  def mat(type=:double)
    MatrixFactory[type]
  end

  # Construct a matrix of all zeros.
  #
  #   zeros(2, 3) == mat[[0, 0, 0],[0, 0, 0]]
  def zeros(n,m=nil)
    if m
      mat.zeros(n,m)
    else
      mat.zeros(n)
    end
  end

  # Construct a matrix of all ones.
  #
  #   ones(2, 3) == mat[[1, 1, 1],[1, 1, 1]]
  def ones(n,m=nil)
    if m
      mat.ones(n,m)
    else
      mat.ones(n)
    end
  end

  # Return the diagonal of a matrix or return a matrix whose diagonal
  # is specified by the vector
  def diag(x)
    if Array === x
      mat.diag(x.to_mat)
    elsif not x.vector?
      x.diag
    else
      mat.diag(x)
    end
  end

  # Return the identity matrix of given size.
  def eye(n)
    mat.eye(n)
  end

  # Construct a matrix or vector with elements randomly
  # drawn uniformly from [0, 1]. With one argument, construct
  # a vector, with two a matrix.
  def rand(n=1,m=nil)
    if m
      mat.rand(n,m)
    else
      mat.rand(n)
    end
  end

  # Construct a matrix or vector with elements randomly drawn from a
  # Gaussian distribution with mean 0 and variance 1. With one
  # argument, construct a vector, with two a matrix.
  def randn(n=1,m=nil)
    if m
      mat.randn(n,m)
    else
      mat.randn(n)
    end
  end

  FUNCTIONS = %w(abs acos asin atan cbrt ceil cos cosh exp floor log log10 signum sin sinh sqrt tan tanh)

  FUNCTIONS.each do |fn|
    module_eval <<-EOS
      def #{fn}(x)
        if Array === x
          x = x.to_mat
        end
        s = MatrixFunctions.#{fn}(x)
      end
      module_function :#{fn}

      def #{fn}i(x)
        MatrixFunctions.#{fn}i(x)
      end
      module_function :#{fn}i

      alias #{fn}! #{fn}i
    EOS
  end

  # Computer power. pow(x, y) = x ^ y.
  def pow(x, y)
    x = x.to_mat if Array === x
    y = y.to_amt if Array === y
    return MatrixFunctions.pow(x, y)
  end

  # Compute power, in-place.
  def powi(x, y)
    MatrixFunctions.powi(x, y)
  end

  alias pow! powi

  PI = Math::PI

  # Computing the trace of a matrix.
  def trace(x)
    JBLAS::check_matrix_square(x)
    x.diag.sum
  end

  # Computing the eigenvalues of matrix.
  def eig(x)
    raise(ArgumentError,
          'eigenvalues only defined for square matrices') unless x.square?
    if x.symmetric?
      return Eigen.symmetric_eigenvalues(x)
    else
      raise 'General eigenvalues not implemented (yet)'
    end
  end

  # Computing the eigenvectors of matrix.
  #
  #   u, v = eigv(x)
  #
  # u are the eigenvalues and v is a diagonal matrix containing the
  # eigenvalues
  def eigv(x)
    JBLAS::check_matrix_square(x)
    if x.symmetric?
      return Eigen.symmetric_eigenvectors(x)
    else
      raise 'General eigenvectors not implemented (yet)'
    end
  end

  # Solve the linear equation a*x = b. See also MatrixMixin#solve.
  def solve(a, b)
    a.solve b
  end

  # Compute the norm of a vector
  def norm(x, type=2)
    case type
    when 1
      x.norm1
    when 2
      x.norm2
    when :inf
      x.normmax
    end
  end

  # Returns the horizontal concatenation of all arguments
  def hcat(*args)
    args.map {|s| s.to_matrix}.inject{|s,x| s = s.hcat x}
  end

  # Returns the vertical concatenation of all arguments
  def vcat(*args)
    args.map {|s| s.to_matrix}.inject{|s,x| s = s.vcat x}
  end

  # Replicate a matrix a certain number of horizontal and
  # vertical times.
  #
  # For example:
  #
  #     repmat(mat[[1,2,3],[4,5,6]], 1, 2)
  #     => [1.0, 2.0, 3.0, 1.0, 2.0, 3.0; 4.0, 5.0, 6.0, 4.0, 5.0, 6.0]
  def repmat(m, r, c)
    m.to_matrix.repmat(r, c)
  end

  # Generate an array of linearily spaced points.
  def linspace(a, b, n)
    (0...n).map do |i|
      t = Float(i) / (n-1)
      (1-t)*a + t*b
    end
  end

  # Generate an array of logarithmically spaced points.
  def logspace(a, b, n)
    (0...n).map do |i|
      t = Float(i) / (n-1)
      10**( (1-t)*a + t*b )
    end
  end

  # Generate a range from a to b with step size s.
  def range(a, s, b)
    x = []
    while a < b
      x << a
      a += s
    end
    return x
  end

  # The sum of a vector.
  def sum(x)
    x.sum
  end

  # The mean of a vector.
  def mean(x)
    x.to_mat.mean
  end

  # Sort the elements of a vector.
  def sort(x)
    x.sort
  end

  # Return the smallest element of a vector.
  def min(x)
    x.min
  end

  # Return the largest element of a vector.
  def max(x)
    x.max
  end

  # The sinc function (Defined as sin(x)/x if x != 0 and 1 else).
  def sinc(x)
    sin(x) / x
  end

  # Compute the cumulative sum of a vector.
  def cumsum(x)
    x.cumulative_sum
  end
end
