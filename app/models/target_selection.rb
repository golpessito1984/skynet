# frozen_string_literal: true

class TargetSelection
  attr_accessor :attack_mode, :radar

  def initialize(targets)
    parse_targets(targets)
  end
  
  def order_by_position(type = 'ASC')
    if type == 'ASC'
      @radar.sort! { |position_a, position_b| position_a[:position].distance <=> position_b[:position].distance }
    elsif type == 'DESC'
      @radar.sort! { |position_a, position_b| position_a[:position].distance <=> position_b[:position].distance }.reverse!
    end
    @radar
  end

  def avoid_cross_fire
    @radar.reject! {|position_target| position_target[:targets].any? {|target| target.type == 'Human' }}
  end

  def priroize_t_x
    @radar.sort! { |p_a, p_b| count_t_x(p_a[:targets]) <=> count_t_x(p_b[:targets])}.reverse!
  end

  private

  def parse_targets(targets)
    targets = JSON.parse(targets)
    @attack_mode = targets['attack-mode']
    @radar = []
    targets['radar'].each do |position_target|
      target = set_position(position_target)
      target[:targets] = set_targets(position_target)
      @radar << target
    end
  end

  def set_position(position_target)
    target = {}
    position = position_target['position']
    target[:position] = Point.new(position['x'], position['y'])
    target
  end

  def set_targets(position_target)
    targets = []
    position_target['targets'].each do |target_json|
      type = target_json['type']
      damage = target_json['damage'] || 0
      target = Target.new(type, damage)
      targets << target
    end
    targets
  end

  def count_t_x(targets)
    targets.inject(0){|sum,target| sum +  (target.type == "T-X" ? 1 : 0)}
  end

end
