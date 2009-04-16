require 'jblas'

raise <<EOS
Do not "require" this file it is only for providing documentation to
methods implemented in Java
EOS

module JBLAS
  module MatrixMixin
    # Return a transposed view of this matrix. See also MatrixMixin#t
    def transpose; end

    # Return a copy of column +c+.
    def get_column(c); end
    
    # Return a copy of a row +r+.
    def get_row(r); end
   
  end
end
