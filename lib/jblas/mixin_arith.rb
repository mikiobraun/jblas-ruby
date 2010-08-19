# Syntactic sugar for arithmetic operations. See JBLAS::MatrixArithMixin.

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
  # Mixin for syntactic sugar for arithmetic operations.
  #
  # Collected in MatrixMixin.
  #
  # Roughly defines the following types of operators:
  # * arithmetic (+,-,*,/,...)
  # * logical operations (|,&,...)
  # * logical tests (==,>,<,...)
  # * arithmetic operations with column and row vectors (add_column_vector, ...)
  #
  module MatrixArithMixin
    # Add _o_ to this matrix. Works with matrices and scalars.
    def +(o); add(o); end
    # Subtract _o_ from this matrix. Works with matrices and scalars.
    def -(o); sub(o); end
    # Multiply this matrix with _o_. If _o_ is a matrix, this
    # matrix-matrix multiplication. If you want element-wise
    # multiplication, you must use +emul+
    def *(o); mmul(o); end
    # Divide this matrix by _o_.
    def /(o); div(o); end
    # Negating a matrix
    def -@; neg; end

    # Element-wise test on less-than with _o_.
    def <(o); lt(o); end
    # Element-wise test on less-than-or-equal with _o_.
    def <=(o); le(o); end
    # Element-wise test on greater-than with _o_.
    def >(o); gt(o); end
    # Element-wise test on greater-than-or-equal with _o_.
    def >=(o); ge(o); end
    # Element-wise test on equality with _o_.
    def ===(o); eq(o); end

    # Add matrices in-place.
    def add!(s); addi(s); end
    # Subtract matrices in-place.
    def sub!(s); subi(s); end
    # Multiply matrices element-wise in-place.
    def mul!(s); muli(s); end
    # Matrix multiply matrices in-place.
    def mmul!(s); mmuli(s); end
    # Divide matrices element-wise in-place.
    def div!(s); divi(s); end
    # Element-wise test for equality in-place.
    def eq!(s); eqi(s); end
    # Element-wise test for inequality in-place.
    def ne!(s); nei(s); end
    # Element-wise test for less-than in-place.
    def lt!(s); lti(s); end
    # Element-wise test for less-than-or-equal in-place.
    def le!(s); lei(s); end
    # Element-wise test for greater-than in-place.
    def gt!(s); gti(s); end
    # Element-wise test for greater-than-or-equal in-place.
    def ge!(s); gei(s); end
    # Element-wise logical "and" in-place.
    def and!(s); andi(s); end
    # Element-wise logical "or" in-place.
    def or!(s); ori(s); end
    # Element-wise logical exclusive-or in-place.
    def xor!(s); xori(s); end

    # Add column vector to matrix in-place.
    def add_column_vector!(s); addi_column_vector(s); end
    # Add row vector to matrix in-place.
    def add_row_vector!(s); addi_row_vector(s); end
    # Subtract column vector from matrix in-place.
    def sub_column_vector!(s); subi_column_vector(s); end
    # Subtract column vector from matrix in-place.
    def sub_row_vector!(s); subi_row_vector(s); end
    # Multiply row vector element-wise with matrix in-place.
    def mul_column_vector!(s); muli_column_vector(s); end
    # Divide matrix element-wise by column vector in-place.
    def mul_row_vector!(s); muli_row_vector(s); end
    # Multiply row vector element-wise with matrix in-place.
    def div_column_vector!(s); divi_column_vector(s); end
    # Divide matrix element-wise by row vector in-place.
    def div_row_vector!(s); divi_row_vector(s); end

    # Test on equality.
    def ==(o)
      #puts "== called with self = #{self.inspect}, o = #{o.inspect}"
      equals(o)
    end

    # Element-wise logical and.
    def &(o); self.and(o); end
    # Element-wise logical or.
    def |(o); self.or(o); end
    # Element-wise logical exclusive-or.
    def ^(o); self.xor(o); end

    # Compute self to the power of o.
    def **(o); MatrixFunctions.pow(self, o); end

    def coerce(o) # :nodoc:
      case o
      when Numeric
        return ReversedArithmetic.new(self), o
      else
        return self, o
      end
      #unless self.class === o
      #  [ReversedArithmetic.new(self), o]
      #end
    end

    # Documentation for Java methods
    if false
      # Add matrices (see also +).
      def add(o); JAVA_METHOD; end
      # Add matrices in-place (see also add!).
      def addi(o, result=self); JAVA_METHOD; end

      # Subtract matrices (see also -).
      def sub(o); JAVA_METHOD; end
      # Subtract matrices in-place (see also sub!).
      def subi(o, result=self); JAVA_METHOD; end

      # Multiply matrices element-wise. (see also *)
      def mul(o); JAVA_METHOD; end
      # Multiply matrices element-wise in-place. (see also mul!)
      def muli(o, result=self); JAVA_METHOD; end

      # Divide matrices element-wise (see also /)
      def div(o); JAVA_METHOD; end
      # Divide matric element-wise in-place (see also div!)
      def divi(o, result=self); JAVA_METHOD; end
    end
  end
end