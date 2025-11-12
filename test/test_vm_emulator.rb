# frozen_string_literal: true

require 'minitest/autorun'
require 'vm_emulator'

class TestVM < Minitest::Test
  def test_new_vm_not_running
    vm = VMEmulator::VM.simple('a')
    assert !vm.running?
    assert_nil vm.to_mem_stat
  end
end
