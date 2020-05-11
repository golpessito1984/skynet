require 'rails_helper'

RSpec.describe TargetSelection, type: :model do
  before(:each) do
    @targets = {"attack-mode":["closest-first"],
                "radar":[{"position":{"x":0,"y":40},
                          "targets":[{"type":"T1","damage":30},
                                     {"type":"T-X","damage":80},
                                     {"type": "Human"}]},
                         {"position":{"x":0,"y":60},
                          "targets":[{"type":"T-X","damage":80}]}]}.to_json

    @target_selection = TargetSelection.new(@targets)
  end
  context 'with valid attack­mode and radars [position - target]' do
    it 'can create target selection' do
      @target_selection = TargetSelection.new(@targets)
      expect(@target_selection.attack_mode).to eq(["closest-first"])
      expect(@target_selection.radar[0][:position].x).to eq(0)
      expect(@target_selection.radar[0][:position].y).to eq(40)
      expect(@target_selection.radar[1][:position].x).to eq(0)
      expect(@target_selection.radar[1][:position].y).to eq(60)
      expect(@target_selection.radar[0][:targets][0].type).to eq("T1")
      expect(@target_selection.radar[0][:targets][0].damage).to eq(30)
      expect(@target_selection.radar[0][:targets][1].type).to eq("T-X")
      expect(@target_selection.radar[0][:targets][1].damage).to eq(80)
      expect(@target_selection.radar[0][:targets][2].type).to eq("Human")
      expect(@target_selection.radar[0][:targets][2].damage).to eq(0)
    end

    it 'can order by position ASC' do
      @target_selection.order_by_position
      expect(@target_selection.radar[0][:position].x).to eq(0)
      expect(@target_selection.radar[0][:position].y).to eq(40)
    end

    it 'can order by position DESC' do
      @target_selection.order_by_position("DESC")
      expect(@target_selection.radar[0][:position].x).to eq(0)
      expect(@target_selection.radar[0][:position].y).to eq(60)
    end

    it 'can avoid human' do
      @target_selection.avoid_cross_fire
      @target_selection.radar.each do |position_target|
        targets = position_target[:targets]
        targets.each do |target|
          expect(target.type).not_to eq("Human")
        end
      end
    end

    it 'Priorize­t­x' do
      @target_selection.priorize_t_x
      expect(@target_selection.radar[0][:position].x).to eq(0)
      expect(@target_selection.radar[0][:position].y).to eq(60)
    end
  end

  it 'can order target by damage' do
    position = 0
    targets = @target_selection.order_by_damage(position)
    expect(targets[0].type).to eq("T-X")
    expect(targets[0].damage).to eq(80)
  end

  it 'can select target' do
    target_selected = @target_selection.select_target
    expect(target_selected[:position][:x]).to eq(0)
    expect(target_selected[:position][:y]).to eq(40)
    expect(target_selected[:targets]).to match_array(["T-X","T1"])
  end

end
