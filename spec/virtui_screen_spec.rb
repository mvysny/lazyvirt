require_relative 'spec_helper'
require 'virtcache'
require 'vm_emulator'
require 'virtui_screen'
require 'timecop'

describe VMWindow do
  let(:now) { Time.now }
  let(:window) do
    cache = Timecop.freeze(now) { VirtCache.new(VMEmulator.demo) }
    w = Timecop.freeze(now + 5) do
      cache.update
      VMWindow.new(cache, Ballooning.new(cache))
    end
    w.active = true
    w
  end

  it 'has the right content' do
    content = window.content.map { Rainbow.uncolor(it) }
    assert_equal '⏹ BASE', content[0]
    assert_equal '    vda: [##########          ] 64G/128G, host qcow2 0.0%', content[1]
    assert_equal '⏹ Fedora', content[2]
    assert_equal '    vda: [##########          ] 64G/128G, host qcow2 0.0%', content[3]
    assert_equal '▶ Ubuntu 🎈   Host RSS RAM: 3.1G/8G (39%)', content[4]
    assert_equal '    Guest CPU: [                    ] 0.0%; 1 #cpus', content[5]
    assert_equal '    Guest RAM: [#####               ] 2G/7.9G (25%)', content[6]
    assert_equal '    vda: [##########          ] 64G/128G, host qcow2 0.0%', content[7]
    assert_equal '▶ win11 🎈   Host RSS RAM: 3.1G/8G (39%)', content[8]
    assert_equal '    Guest CPU: [                    ] 0.0%; 1 #cpus', content[9]
    assert_equal '    Guest RAM: [#####               ] 2G/7.9G (25%)', content[10]
    assert_equal '    vda: [##########          ] 64G/128G, host qcow2 0.0%', content[11]
  end

  context('cursor selection') do
    it 'moves cursor down correctly' do
      assert_equal 0, window.selection.selected
      # first VM is stopped and takes 2 lines
      window.handle_key("\e[B")
      assert_equal 2, window.selection.selected
      # second VM is running and takes 3 lines
      window.handle_key("\e[B")
      assert_equal 4, window.selection.selected
      # third VM is running and takes 3 lines
      window.handle_key("\e[B")
      assert_equal 8, window.selection.selected
      # no more VMs
      window.handle_key("\e[B")
      assert_equal 8, window.selection.selected
    end
  end
end
