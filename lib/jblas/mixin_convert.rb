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
  end
end