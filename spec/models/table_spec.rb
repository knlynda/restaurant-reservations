require 'spec_helper'

describe Table do
  it { should have_one(:reservation) }

  context 'validation' do
    it { should validate_presence_of(:number) }
    it { should validate_numericality_of(:number) }
    it { should validate_uniqueness_of(:number) }
  end
end