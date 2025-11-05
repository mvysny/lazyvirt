require 'minitest/autorun'
require 'formatter'

class TestFormatter < Minitest::Test
  def initialize(test)
    super(test)
    @f = Formatter.new
  end

  def test_progress_bar_empty
    assert_equal '', @f.progress_bar(0, 100, {})
    assert_equal '', @f.progress_bar(100, 0, {})
  end

  def test_progress_bar_simple
    assert_equal "\e[31m# \e[0m", @f.progress_bar(2, 100, { 50 => :red })
    assert_equal '  ', @f.progress_bar(2, 100, { 0 => :red })
  end

  def test_progress_bar_multi
    assert_equal "\e[34maa\e[31maaa\e[32maaaaa\e[0m",
                 @f.progress_bar(10, 10, { 15 => :green, 5 => :red, 2 => :blue }, 'a')
  end
end
