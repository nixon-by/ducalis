# frozen_string_literal: true

require 'spec_helper'
require './lib/ducalis/cops/multiple_times'

RSpec.describe Ducalis::MultipleTimes do
  subject(:cop) { described_class.new }

  it '[rule] raises if method contains more then one Time.current calling' do
    inspect_source(cop, [
                     'def initialize(plan)',
                     '  @year = plan[:year] || Date.current.year',
                     '  @quarter = plan[:quarter] || quarter(Date.current)',
                     'end'
                   ])
    expect(cop).to raise_violation(/multiple/, count: 2)
  end

  it 'raises if method contains mix of different time-related calls' do
    inspect_source(cop, [
                     'def initialize(plan)',
                     '  @hour = plan[:hour] || Time.current.hour',
                     '  @quarter = plan[:quarter] || quarter(Date.current)',
                     'end'
                   ])
    expect(cop).to raise_violation(/multiple/, count: 2)
  end

  it 'raises if method contains more then one Date.today calling' do
    inspect_source(cop, [
                     'def range_to_change',
                     '  [Date.today - RATE_CHANGES_DAYS,',
                     '   Date.today + RATE_CHANGES_DAYS]',
                     'end'
                   ])
    expect(cop).to raise_violation(/multiple/, count: 2)
  end

  it 'raises if block contains more then one Date.today calling' do
    inspect_source(cop, [
                     'validates :year,',
                     '  inclusion: {',
                     '    in: Date.current.year - 1..Date.current.year + 2',
                     '  }'
                   ])
    expect(cop).to raise_violation(/multiple/, count: 2)
  end
end