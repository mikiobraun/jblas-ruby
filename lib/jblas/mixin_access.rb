# Mixins and extensions for acessing elements.

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

class Numeric # :nodoc:
  def to_jblas_index
    self
  end
end

module Enumerable # :nodoc:
  def to_jblas_index
    to_a.to_java :int
  end
end

module JBLAS
  # Mixin for all kinds of element access.
  #
  # This mixin is collected into MatrixMixin.
  module MatrixAccessMixin
    # Get the entry at _i_, _j_. If _j_ is omitted, linear
    # addressing is used (that is, _i_ just enumerates all entries
    # going down rows first.)
    def [](i, j=nil)
      if j
        get(i.to_jblas_index, j.to_jblas_index)
      else
        get(i.to_jblas_index)
      end
    end

    # Set the entry at _i_, _j_ to _v_.  If _j_ is omitted, linear
    # addressing is used (that is, _i_ just enumerates all entries
    # going down rows first.)
    def []=(i, j, v=nil)
      if v
        put(i.to_jblas_index, j.to_jblas_index, v)
      else
        put(i.to_jblas_index, j)
      end
    end

    # column(i) returns the _i_ th column. You can assign
    # to column(i), for example a.column(i) = v,
    # if +v+ is a vector, or you can access the entries of the column via
    # a.column(i)[j] = 1.0.
    def column(i)
      MatrixColumnProxy.new(self, i)
    end

    # row(i) returns the _i_ th row. You can assign
    # to row(i), for example a.row(i) = v, if +v+ is a vector.
    def row(i)
      MatrixRowProxy.new(self, i)
    end
  end
end