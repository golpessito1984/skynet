# frozen_string_literal: true

class TargetSelection
  attr_accessor :attack_mode, :radar

  def initialize(targets)
    parse_targets(targets)
  end

  def select_target
    @attack_mode.each do |attack_mode|
      case attack_mode
      when "Closest­first"
        order_by_position
      when "Furthest­first​ :"
        order_by_position("DESC")
      when "Avoid­crossfire"
        avoid_cross_fire
      when "Priorize­t­x"
        priroize_t_x
      end
    end
    order_by_damage(0)
    avoid_human_target(0)
    target_selected = format_position_target(@radar[0])
    target_selected
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

  def priorize_t_x
    @radar.sort! { |p_a, p_b| count_t_x(p_a[:targets]) <=> count_t_x(p_b[:targets])}.reverse!
  end

  def order_by_damage(position)
    targets = @radar[position][:targets]
    targets.sort! { |target_a, target_b| target_a.damage <=> target_b.damage }.reverse!
  end

  def avoid_human_target(position)
    targets = @radar[position][:targets]
    targets.reject! { |target| target.type == "Human"}
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

  # [{:position=>#<Point:0x0000560258691f80 @x=0.0, @y=40.0>,
  #   :targets=>[#<Target:0x0000560258691e40 @damage=80.0, @type="T-X">, #<Target:0x0000560258691e90 @damage=30.0, @type="T1">]},
  #  {:position=>#<Point:0x0000560258691da0 @x=0.0, @y=60.0>, :targets=>[#<Target:0x0000560258691d28 @damage=80.0, @type="T-X">]}]
  def format_position_target(position_target)
    point = position_target[:position]
    position_targets = position_target[:targets]
    position_targets_types = position_targets.map { |position_target| position_target.type}
    target = {position: {x: point.x.floor, y: point.y.floor}, targets: position_targets_types}
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
