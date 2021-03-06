# frozen_string_literal: true

SingleCov.covered!

require 'spec_helper'
require './lib/ducalis/cops/only_defs'

RSpec.describe Ducalis::OnlyDefs do
  subject(:cop) { described_class.new }

  it 'ignores classes with one instance method' do
    inspect_source([
                     'class TaskJournal',
                     '  def initialize(task)',
                     '    # ...',
                     '  end',
                     '',
                     '  def call(args)',
                     '    # ...',
                     '  end',
                     'end'
                   ])
    expect(cop).not_to raise_violation
  end

  it 'ignores classes with mixed methods' do
    inspect_source([
                     'class TaskJournal',
                     '  def self.find(task)',
                     '    # ...',
                     '  end',
                     '',
                     '  def call(args)',
                     '    # ...',
                     '  end',
                     'end'
                   ])
    expect(cop).not_to raise_violation
  end

  it '[rule] raises error for class with ONLY class methods' do
    inspect_source([
                     'class TaskJournal',
                     '',
                     '  def self.call(task)',
                     '    # ...',
                     '  end',
                     '',
                     '  def self.find(args)',
                     '    # ...',
                     '  end',
                     'end'
                   ])
    expect(cop).to raise_violation(/class methods/)
  end

  it '[rule] better to use instance methods' do
    inspect_source([
                     'class TaskJournal',
                     '  def call(task)',
                     '    # ...',
                     '  end',
                     '',
                     '  def find(args)',
                     '    # ...',
                     '  end',
                     'end'
                   ])
    expect(cop).not_to raise_violation
  end

  it 'raises error for class with ONLY class << self' do
    inspect_source([
                     'class TaskJournal',
                     '  class << self',
                     '    def call(task)',
                     '      # ...',
                     '    end',
                     '',
                     '    def find(args)',
                     '      # ...',
                     '    end',
                     '  end',
                     'end'
                   ])
    expect(cop).to raise_violation(/class methods/)
  end

  it 'ignores inherited classes' do
    inspect_source([
                     'class TaskJournal < BasicJournal',
                     '  def self.call(task)',
                     '    # ...',
                     '  end',
                     '',
                     '  def self.find(args)',
                     '    # ...',
                     '  end',
                     'end'
                   ])
    expect(cop).to_not raise_violation
  end

  it 'ignores instance methods mixed with ONLY class << self' do
    inspect_source([
                     'class TaskJournal',
                     '  class << self',
                     '    def call(task)',
                     '      # ...',
                     '    end',
                     '  end',
                     '',
                     '  def find(args)',
                     '    # ...',
                     '  end',
                     'end'
                   ])
    expect(cop).not_to raise_violation
  end
end
