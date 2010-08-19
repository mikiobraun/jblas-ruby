# jblas-ruby - fast linear algebra for JRuby
# (c) 2009-2010 by Mikio L. Braun and contributors
#
# Version 1.1, August 20, 2010
# (jblas-ruby follows jblas (http://jblas.org) version numbers, although
# jblas-ruby is somewhat more unstable)
#
# Homepage: http://mikiobraun.github.com/jblas-ruby/
#
# This is only the rdoc starting page. For more information, have a look at
# the JBLAS module.
#
# jblas-ruby is under a BSD style license. See the file COPYING.
#
# = Relationship to jblas
#
# jblas-ruby started as being a somewhat thin layer around the jblas library.
# In the beginning, I only added syntatic sugar for arithmetic operations.
# From that, jblas-ruby has evolved somewhat towards a more M*TLAB like environment.
# For example, many methods like DoubleMatrix#diag are also available as
# functions such that you can say the more natural diag(x) instead of x.diag.
#
# I also tried to cover most of the Java methods in the documentation, such that
# you don't need to be proficient in jblas to be able to work with jblas.
# Occasionally, things may just not work the way you expect them due to some
# strange typing error. I apologize for all the cases where this happens.