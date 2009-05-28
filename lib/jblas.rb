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

require 'java'
begin
  require 'jblas-0.2.jar'
rescue LoadError => e
  begin
    org.jblas.DoubleMatrix
  rescue NameError => e
    raise LoadError, 'Cannot load jblas.jar, and it also does not seem to be in the CLASSPATH'
  end
end

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
# By adding the suffix "i" to the method functions, you again perform the 
# computation in-place. For example
#
#   exp(x)
#
# returns a copy of +x+, but
#
#   x.expi
# 
# does not.
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
  # Java Classes Import
  #
  ######################################################################

  unless JBLAS < Java
    include Java
        
    import org.jblas.DoubleMatrix
    import org.jblas.FloatMatrix
    import org.jblas.SimpleBlas
    import org.jblas.DoubleFunction
    import org.jblas.FloatFunction
    
    import org.jblas.Solve
    import org.jblas.Eigen
    import org.jblas.Geometry
    import org.jblas.MatrixFunctions
  end

  ######################################################################
  #
  # Matrices
  #
  ######################################################################

  # Extensions to matrix classes (mostly arithmetics). This mixin is
  # then used to automatically enrich the DoubleMatrix and FloatMatrix
  # classes
  module MatrixMixin
    include Enumerable

    ######################################################################
    #
    # Add class members
    #
    def self.append_features(targetClass)
      def targetClass.[](*data)
        from_array data
      end
    
      def targetClass.from_array(data)
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
      super
    end

    ######################################################################
    #
    # Instance members
    #

    # Get the entry at _i_, _j_
    def [](i, j=nil)
      if j
        rget(i, j)
      else
        rget(i)
      end
    end
    
    # Set the entry at _i_, _j_ to _v_.
    def []=(i, j, v=nil)
      if v
        rput(i, j, v)
      else
        rput(i, j)
      end
    end

    private
    
    def non_java_enum?(o)
      not o.kind_of? JavaProxy and o.kind_of? Enumerable
    end


    def to_java_if_non_java_enum(o)
      if non_java_enum? o
        o.to_a.to_java(:int)
      else
        o
      end
    end

    public

    def rget(i, j=nil)
      i = to_java_if_non_java_enum i
      if j
        j = to_java_if_non_java_enum j        
        get(i, j)
      else
        get(i)
      end
    end

    def rput(i, j, v=nil)
      i = to_java_if_non_java_enum i
      if v
        j = to_java_if_non_java_enum j
        put(i, j, v)
      else
        put(i, j)
      end
    end

    # Add _o_ to this matrix. Works with matrices and scalars.
    def +(o); add(o.to_mat); end
    # Subtract _o_ from this matrix. Works with matrices and scalars.
    def -(o); sub(o); end
    # Multiply this matrix with _o_. If _o_ is a matrix, this
    # matrix-matrix multiplication. If you want elementwise
    # multiplication, you must use +emul+
    def *(o); mmul(o.to_mat); end
    # Divide this matrix by _o_.
    def /(o); div(o.to_mat); end
    # Negating a matrix
    def -@; neg; end

    # Elementwise test on less-than with _o_.
    def <(o); lt(o.to_mat); end
    # Elementwise test on less-than-or-equal with _o_.
    def <=(o); le(o.to_mat); end
    # Elementwise test on greater-than with _o_.
    def >(o); gt(o.to_mat); end
    # Elementwise test on greater-than-or-equal with _o_.
    def >=(o); ge(o.to_mat); end
    # Elementwise test on equality with _o_.
    def ===(o); eq(o.to_mat); end
    
    %w(add sub mul mmul div eq ne lt le gt ge and or xor).each do |s|
      module_eval "def #{s}!(*args); #{s}i(*args); end"
    end

    # Test on equality.
    def ==(o)
      #puts "== called with self = #{self.inspect}, o = #{o.inspect}"
      equals(o.to_mat)
    end
    
    # Elementwise and with _o_
    def &(o); self.and(o.to_mat); end
    # Elementwise or with _o_
    def |(o); self.or(o.to_mat); end
    # Elementwise xor with _o_
    def ^(o); self.xor(o.to_mat); end

    def **(o); MatrixFunctions.pow(self, o); end
  
    def coerce(o) #:nodoc:
      unless self.class === o
        [ReversedArithmetic.new(self), o]
      end
    end
    
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
    
    # <tt>column(i)</tt> returns the <em>i</em>th column. You can assign 
    # to <tt>column(i)</tt>, for example <tt>a.column(i) = v</tt>, 
    # if +v+ is a vector, or you can access the entries of the column via
    # <tt>a.column(i)[j] = 1.0</tt>
    def column(i)
      MatrixColumnProxy.new(self, i)  
    end
    
    # Return a matrix whose columns are specified by +indices+. You
    # actually obtain a copy of those columns.
    #def columns(indices)
    #  cols = indices.map {|i| column_vector(i)}.to_java DoubleVector
    #  #cols = getColumnVectors(indices.to_java :int)
    #  DoubleMatrix.fromColumnVectors cols
    #end
    
    # <tt>row(i)</tt> returns the <em>i</em>th row. You can assign 
    # to <tt>row(i)</tt>, for example <tt>a.row(i) = v</tt>, 
    # if +v+ is a vector.
    def row_proxy(i)
      MatrixRowProxy.new(self, i)
    end
    
    # Return a matrix whose rows are specified by +indices+. You
    # actually obtain a copy of these rows.
    #def rows(indices)
    #  rows = indices.map {|i| row_vector(i)}.to_java DoubleVector
    #  DoubleMatrix.fromRowVectors rows
    #end
    
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
  
    # Iterate over rows. This is also what a plain +each+ does,
    # such that a matrix looks like an array of its rows.
    def each_row
      (0...rows).each do |i|
        yield row(i)
      end
    end

    # Iterate over columns.
    def each_column
      (0...columns).each do |j|
        yield column(j)
      end
    end

    def map_column
      (0...columns).map do |j|
        yield column(j)
      end
    end

    # +each+ iterates over each element
    def each
      (0...length).each do |i|
        yield get(i)
      end
    end

    def map!(&block)
      (0...length).each do |i|
        put(i, block.call(get(i)))
      end
      return self
    end

    def map(&block)
      return dup.map!(&block)
    end
    
    def to_s(fmt=nil, coljoin=', ', rowjoin='; ')
      if fmt
        x = to_ary
        '[' + x.map do |r|
          if Enumerable === r
            r.map {|e| sprintf(fmt, e)}.join(coljoin)
          else
            sprintf(fmt, r)
          end
        end.join(rowjoin) + ']'
      else
        toString
      end
    end
    
    def inspect
      s = "<#{self.class} of size #{rows} #{columns}: #{to_s}>"
    end

    def to_ary #:nodoc:
      if columns == 1
        (0...length).map {|i| get(i)}
      else
        (0...rows).map do |i|
          (0...columns).map do |j|
            get(i,j)
          end
        end
      end 
    end

    def to_a #:nodoc:
      self
    end

    def to_mat #:nodoc:
      self
    end

    def to_matrix 
      self
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
      self.solve(self.class.eye(size[0]))
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
  end # module MatrixMixin
  
  class MatrixElementWiseProxy
    def initialize(matrix)
      @matrix = matrix
    end
    
    def *(other)
      @matrix.mul(other)
    end
  end
  
  class MatrixDotProxy
    def initialize(matrix)
      @matrix = matrix
    end
    
    def *(other)
      @matrix.dot(other)
    end
  end
  
  class MatrixColumnProxy
    def initialize(matrix, column)
      @matrix = matrix
      @column = column
    end
    def [](i); @matrix.get(i, @column); end
    def []=(i, v); @matrix.put(i, @column, v); end
    def to_mat; @matrix.get_column(@column); end
  end
  
  class MatrixRowProxy
    def initialize(matrix, row)
      @matrix = matrix
      @row = row
    end
    def [](i); @matrix.get(@row, i); end  
    def []=(i, v); @matrix.put(@row, i, v); end
    def to_mat; @matrix.get_row(@column); end
  end
    
  # When arguments to arithmetic operators are promoted via coerce, they
  # change their order. This class is a wrapper for the promoted self
  # which has <tt>-</tt> and <tt>/</tt> overloaded to call +rsub+ and 
  # +rdiv+ instead of +div+ and +sub+
  class ReversedArithmetic
    def initialize(o)
      @value = o;
    end

    def +(o)
      @value.add o
    end

    def *(o)
      @value.mul o
    end

    def -(o)
      @value.rsub o
    end

    def /(o)
      @value.rdiv o
    end
  end

  class DoubleMatrix
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
    include MatrixMixin
  end

  ######################################################################
  #
  # Helper methods
  #
  ######################################################################

  def self.check_matrix_square(m)
    unless m.square?
      raise ArgumentError, "Matrix is not square."
    end
  end

  ######################################################################
  #
  # Module Functions
  #
  ######################################################################

  module_function

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
  #   zerso(2, 3) == mat[[0, 0, 0],[0, 0, 0]]
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

  # Return the identity matrix.
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

      def #{fn}i(x)
        MatrixFunctions.#{fn}i(x)
      end
    EOS
  end

  def pow(x, y)
    x = x.to_mat if Array === x
    y = y.to_amt if Array === y
    return MatrixFunctions.pow(x, y)
  end

  def powi(x, y)
    MatrixFunctions.powi(x, y)
  end

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

  def repmat(m, r, c)
    m.to_matrix.repmat(r, c)
  end

  # Linearily spaced points
  def linspace(a, b, n)
    (0...n).map do |i|
      t = Float(i) / (n-1)
      (1-t)*a + t*b
    end
  end

  # Logarithmically spaced points
  def logspace(a, b, n)
    (0...n).map do |i|
      t = Float(i) / (n-1)
      10**( (1-t)*a + t*b )
    end
  end    

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

  def sinc(x)
    sin(x) / x
  end
  
  def cumsum(x)
    x.cumulative_sum
  end
end

#
# Extending every object play with matrices in a hopefully
# most natural manner.
#

class Object
  def to_matrix
    to_mat
  end
end

class Numeric #:nodoc:
  def to_mat
    self # JBLAS::DoubleMatrix[self]
  end

  def to_matrix
    JBLAS::DoubleMatrix[self]
  end

  def columns
    1
  end

  def rows
    1
  end

  def [](*args)
    self   
  end

  def scalar?
    true
  end

  def t
    self
  end

  def length
    1
  end
end

class Array #:nodoc:
  def to_mat
    JBLAS::DoubleMatrix[*self]
  end
  
  def to_matlab_string
    '[' + map{|e| e.to_s}.join(', ') + ']'
  end

  def to_index_array
    to_java :int
  end
end 

class Range #:nodoc:
  def to_mat
    self.to_a.to_mat
  end
end
