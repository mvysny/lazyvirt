# frozen_string_literal: true

require 'rake/testtask'
require 'yard'

Rake::TestTask.new

YARD::Rake::YardocTask.new do |t|
  t.options = [
    '--title', 'LazyVirt: TUI client for libvirt',
    '--main', 'README.md',
    '--markup', 'markdown'
  ]
end

