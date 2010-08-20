# Methods added to the Java classes are encoded as mixins in this file.

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
  # Mixin for conversion options.
  #
  # Collected in MatrixMixin.
  module MatrixConvertMixin
    # Convert this matrix to a string.
    #
    # This methods takes a few extra arguments to control how the result looks
    # like.
    #
    # +fmt+ is a format as used by sprintf, +coljoin+ is the string used to
    # join column, +rowjoin+ is what is used to join rows. For example,
    #
    #    x.to_s('%.1f', ' ', "\n")
    #
    # Returns a matrix where columns are separated by spaces, rows by newlines
    # and each element is shown with one digit after the comma.
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

    # Return an a representation of this object.
    def inspect
      s = "<#{self.class} of size #{rows} #{columns}: #{to_s}>"
    end

    def rows_to_a
      (0...rows).map do |i|
        row(i).to_a
      end
    end

    def columns_to_a
      (0...columns).map do |j|
        column(j).to_a
      end
    end
    
    # Convert the matrix to an array.
    #
    # If the matrix
    def to_ary
      to_a
    end

    # Return the matrix as an Enumerable (just returns self).
    def to_a #:nodoc:
      data.to_a
    end

    def to_mat #:nodoc:
      self
    end

    def to_matrix
      self
    end
  end
end