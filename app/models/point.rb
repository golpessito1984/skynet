class Point
  attr_accessor :x, :y

  def initialize(x, y)
    begin
      @x = is_number?(x) ? Float(x) : nil
      @y = is_number?(y) ? Float(y) : nil
    rescue ArgumentError => e
      raise e
    end
  end

  def distance
    Math.sqrt((@x ** 2) + (@y ** 2)).round(2)
  end

  private

  def is_number? string
    true if Float(string)
  end
end