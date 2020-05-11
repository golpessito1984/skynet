# frozen_string_literal: true
class Target
  attr_reader :type, :damage

  def initialize(type, damage = 0)
    
      @type = type if valid_type?(type)
      @damage = is_number?(damage) ? Float(damage) : nil
    rescue ArgumentError => e
      raise e
    
  end

  private

  def valid_type?(type)
    true
    # case type
    # when 'T1'
    #   true
    # when 'Human'
    #   true
    # when 'T-X'
    #   true
    # when 'T7-T'
    #   true
    # when 'HK-Tank'
    #   true
    # when 'HK-Bomber'
    #   true
    # when 'HK­Tank'
    #   true
    # else
    #   raise ArgumentError
    # end
  end

  def is_number?(string)
    true if Float(string)
  end
end