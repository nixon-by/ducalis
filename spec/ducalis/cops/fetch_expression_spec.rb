# frozen_string_literal: true

SingleCov.covered!

require 'spec_helper'
require './lib/ducalis/cops/fetch_expression'

RSpec.describe Ducalis::FetchExpression do
  subject(:cop) { described_class.new }

  it '[rule] raises on using [] with default' do
    inspect_source('params[:to] || destination')
    expect(cop).to raise_violation(/fetch/)
  end

  it '[rule] better to use fetch operator' do
    inspect_source('params.fetch(:to) { destination }')
    expect(cop).not_to raise_violation
  end

  it 'raises on using ternary operator with default' do
    inspect_source('params[:to] ? params[:to] : destination')
    expect(cop).to raise_violation(/fetch/)
  end

  it 'raises on using ternary operator with nil?' do
    inspect_source('params[:to].nil? ? destination : params[:to]')
    expect(cop).to raise_violation(/fetch/)
  end

  it 'works for empty file' do
    inspect_source('')
    expect(cop).not_to raise_violation
  end
end
