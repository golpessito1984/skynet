require 'rails_helper'

RSpec.describe Point, type: :model do
  context 'with valid x and y' do
    it 'can create a valid point' do
      point = Point.new(25,50)
      expect(point.x).to eq(25)
      expect(point.y).to eq(50)
    end

    it 'can create a valid point string version' do
      point = Point.new('25','50')
      expect(point.x).to eq(25)
      expect(point.y).to eq(50)
    end
  end

  context 'with invalid x or y' do
    it 'can create a valid point string version' do
      expect {
        Point.new('hello','goodbye')
      }.to raise_error(ArgumentError)
    end
  end

  context 'with valid point' do
    it 'calculate distance' do
      point = Point.new(5,5)
      expect(point.distance).to eq(7.07)
      point = Point.new(3,9)
      expect(point.distance).to eq(9.49)
    end
  end

end