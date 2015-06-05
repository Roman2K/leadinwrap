require 'minitest/autorun'
require 'leadinwrap'

class LeadinwrapTest < MiniTest::Unit::TestCase
  def test_no_wrap
    assert_wraps 3, "", ""
    assert_wraps 3, "a", "a"
    assert_wraps 3, "a b", "a b"
    assert_wraps 3, "a b\n", "a b\n"
  end

  def test_wrap
    assert_wraps 3, "a b\nc", "a b c"
    assert_wraps 3, "a b\nc", "a  b c"
    assert_wraps 3, "ab\nc d\ne", "ab c\nd e"
    assert_wraps 3, "a b\nc", "a\nb c"
    assert_wraps 3, "a\nbcde\nf", "a bcde f"
  end

  def test_wrap_with_indent
    assert_wraps 4, " a b\n c", " a b c"
    assert_wraps 4, " a b\n c", " a\n b\n  c"
    assert_wraps 3, " a\n b\n c", " a b c"
  end

private

  def assert_wraps(width, expected, input)
    indent = lambda { |str| str.gsub(/^(.*)$/) { "> |#{$1}|" } }
    actual = Leadinwrap.wrap(width, input)
    msg = "Expected:\n\n#{indent.(expected)}\n\nActual:\n\n#{indent.(actual)}\n\n"
    assert_equal(expected, actual, msg)
  end
end
