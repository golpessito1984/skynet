require 'rails_helper'

RSpec.describe 'Target', type: :model do
  context 'with valid type and damage' do
    it 'can create a valid target' do
      target = Target.new('T1',30)
      expect(target.type).to eq('T1')
      expect(target.damage).to eq(30)
    end
  end

  context 'with invalid type or damage' do
    it 'can not create a new target' do
      expect {
        Target.new('T1','hello')
      }.to raise_error(ArgumentError)

      expect {
        Target.new('NH48',45)
      }.to raise_error(ArgumentError)
    end
  end

end