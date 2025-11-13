# frozen_string_literal: true

require 'minitest/autorun'
require 'virtcache'
require 'vm_emulator'
require 'timecop'

class TestVirtCache < Minitest::Test
  def test_smoke
    VirtCache.new(VMEmulator.new)
  end

  def test_total_rss_zero
    assert_equal 0, VirtCache.new(VMEmulator.new).total_vm_rss_usage
  end

  def test_total_rss
    Timecop.freeze(Time.now) do
      assert_equal 2_415_919_104, VirtCache.new(vm_emulator_demo).total_vm_rss_usage
    end
  end

  def test_running
    c = VirtCache.new(vm_emulator_demo)
    assert c.running?('Ubuntu')
    assert c.running?('win11')
    assert !c.running?('BASE')
    assert !c.running?('non-existing-cm')
  end
end
