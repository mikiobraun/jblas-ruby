require 'test/unit'
require 'jblas'
require 'pp'

include JBLAS

class TestJblasMixinConvert < Test::Unit::TestCase
  def test_rows_to_a
    x = mat[[1,2,3],[4,5,6]]

    assert_equal [1,4,2,5,3,6], x.to_a
    assert_equal [[1,2,3],[4,5,6]], x.rows_to_a
    assert_equal [[1,4],[2,5],[3,6]], x.columns_to_a
  end
end
