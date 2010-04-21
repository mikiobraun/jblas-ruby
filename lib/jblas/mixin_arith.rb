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
  module MatrixArithMixin
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

    def add!(s); addi(s); end
    def sub!(s); subi(s); end
    def mul!(s); muli(s); end
    def mmul!(s); mmuli(s); end
    def div!(s); divi(s); end
    def eq!(s); eqi(s); end
    def ne!(s); nei(s); end
    def lt!(s); lti(s); end
    def le!(s); lei(s); end
    def gt!(s); gti(s); end
    def ge!(s); gei(s); end
    def and!(s); andi(s); end
    def or!(s); ori(s); end
    def xor!(s); xori(s); end

    def add_column_vector!(s); addi_column_vector(s); end
    def sub_column_vector!(s); subi_column_vector(s); end
    def mul_column_vector!(s); muli_column_vector(s); end
    def div_column_vector!(s); divi_column_vector(s); end

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
  end
end