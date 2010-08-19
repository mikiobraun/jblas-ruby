# Small small example to show some basic operations.
require 'jblas'

include JBLAS

# Create a new 3 x 3 matrix
a = DoubleMatrix.new(3,3)

# Setting entry in row i, column j to i + j
for i in 0...3
  for j in 0...3
    a[i,j] = i + j
  end
end

# print the matrix
puts "a = #{a}"

# Another way to create a matrix
b = DoubleMatrix[[1,2,3],[4,5,6],[7,8,9]]

# Adding the two matrices:
puts "a + b = #{a + b}"

# Matrix mulitplication versus element-wise multiplication
puts "a * b (matrix multiplicaton) = #{a * b}"
puts "a * b (elementwise) = #{a.mul(b)}"

# In-place operations:

# Computes a += b
a.addi b