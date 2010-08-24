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
  def to_indices
    self
  end
end

module Enumerable # :nodoc:
  def to_indices
    to_a.to_java :int
  end
end

class Array # :nodoc:
    # Convert an array to an array useable for indexing.
  def to_indices
    to_java :int
  end
end

module JBLAS
  # Mixin for all kinds of element access.
  #
  # This mixin is collected into MatrixMixin.
  #
  # You have the following options of accessing elements:
  #
  # * <b>Linear access</b>: accessing all elements linearly, going down rows
  #   first (x[i], x.get(i), x.put(i))
  # * <b>Two-dimensional access</b>: Accessing element in row i,
  #   column j (x[i,j], x.get(i,j), x.put(i,j)
  # * <b>Accessing rows and columns</b>: get_row(i), get_column(i), put_row(i), put_column(i), and
  #   also get_rows(i), get_columns(i).
  # * <b>Accessing row and column ranges</b>: get_row_range, get_column_range, get_range
  #
  # As indices, you can use one of the following:
  #
  # * <b>Numbers</b>: x[10], x[3,4], x.getRow(3), etc.
  # * <b>Indices as int[] arrays</b>: Unfortunately, these are bit hard
  #   to construct in JRuby ([1,2,3].to_java :int), therefore the emthod
  #   to_indices is added to Numeric, Enumerable, Array, and the matrices.
  #   Then: `i = [1,2,3]; x[i.to_indices]`.
  # * <b>Matrices</b>: In that case, x.find_indices is called to find the
  #   non-zero elements and use those as indices.
  # * <b>Ranges</b>: See JBLAS::Ranges
  #
  # For some access functions (in particular getting rows and columns), you
  # can also specify where to copy the result to get better performance through
  # suppressing object creations.
  #
  module MatrixAccessMixin
    # Get the entry at _i_, _j_. If _j_ is omitted, linear
    # addressing is used (that is, _i_ just enumerates all entries
    # going down rows first.)
    #
    # As indices you can use numbers, int[] arrays, matrices (non-zero elements
    # are taken as indices then), and ranges.
    def [](i, j=nil)
      if j
        get(i.to_indices, j.to_indices)
      else
        get(i.to_indices)
      end
    end

    # Set the entry at _i_, _j_ to _v_.  If _j_ is omitted, linear
    # addressing is used (that is, _i_ just enumerates all entries
    # going down rows first.)
    #
    # As indices you can use numbers, int[] arrays, matrices (non-zero elements
    # are taken as indices then), and ranges.
    def []=(i, j, v=nil)
      if v
        put(i.to_indices, j.to_indices, v)
      else
        put(i.to_indices, j)
      end
    end

    # Get row of a matrix. Unlike the row(i) method, this method
    # returns a copy of the given row. If result is given, the
    # row is copied in that matrix.
    def get_row(i, result=nil); JAVA_METHOD; end if false

    # Get a number of rows.
    #
    # As indices you can use numbers, int[] arrays, matrices (non-zero elements
    # are taken as indices then), and ranges.
    def get_rows(i); JAVA_METHOD; end if false

    # Get a column of a matrix. Unlike column(i) method, this
    # method returns a copy of the given column.
    def get_column(i); JAVA_METHOD; end if false

    # Get a number of rows.
    #
    # As indices you can use numbers, int[] arrays, matrices (non-zero elements
    # are taken as indices then), and ranges.
    def get_columns(i); JAVA_METHOD; end if false

    # Get a copy of rows i1 .. i2 - 1 from column j.
    def get_row_range(i1, i2, j); JAVA_METHOD; end if false

    # Get a copy of columns j1 .. j2 - 1 from row i.
    def get_column_range(i, j1, j2); JAVA_METHOD; end if false

    # Get a copy of the submatrix with rows i1 .. i2 - 1 and
    # columns j1 .. j2 - 1.
    def get_range(i1, i2, j1, j2); JAVA_METHOD; end if false

    # Return an array usable as an index.
    def to_indices
      self
    end
  end
end