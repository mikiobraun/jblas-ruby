# Mixins for complex numbers. Defines JBLAS::ComplexMixin. See also
# ComplexDouble and ComplexFloat.

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
  # Syntactic sugar for complex numbers.
  #
  # Defines the arithmetic operators *, +, -, /, and coercion such that
  # the complex numbers interact well with the builtin numerics.
  module ComplexMixin
    # Convert to a string.
    def to_s
      "#{real} + #{imag}i"
    end

    # Same as to_s.
    def inspect
      to_s
    end

    # Multiply complex values.
    def *(o); mul(o); end
    # Add complex values.
    def +(o); add(o); end
    # Subtract complex values.
    def -(o); sub(o); end
    # Divide complex values.
    def /(o); div(o); end
    # Negative complex values.
    def -@; neg; end

    # Subtract with swapped operands.
    #
    # This means that a.rsub(b) = b - a. This method is necessary to
    # make coercion work.
    def rsub(o); -self + o; end
    # Divide with swapped operands.
    #
    # This means that a.rdiv(b) = b / a. This method is necessary to
    # make coercion work.
    def rdiv(o); inv * o; end
    
    def coerce(o) #:nodoc:
      unless self.class === o
        [ReversedArithmetic.new(self), o]
      end
    end

    # Compute the square root
    def sqrt; JAVA_METHOD; end

    # Get the length of the complex number
    def abs; JAVA_METHOD; end

    # Get the angle of the complex number
    def arg; JAVA_METHOD; end

    # Get the conjugate of the complex number
    def conj; JAVA_METHOD; end
  end
end