require 'rails_helper'

RSpec.describe TargetSelection, type: :model do
  before(:each) do
    @targets = { "attack-mode": ["closest-first"],
                 "radar": [{ "position": { "x": 0, "y": 40 }, "targets": [{ "type": "T1", "damage": 30 },
                                                                          { "type": "HK-Tank", "damage": 80 },
                                                                          { "type": "Human" }] },
                           { "position": { "x": 0, "y": 15 }, "targets": [{ "type": "T1", "damage": 45 },
                                                                          { "type": "Human" }] },
                           { "position": { "x": 0, "y": 60 }, "targets": [{ "type": "T-X", "damage": 80 },
                                                                          { "type": "T-X", "damage": 120 }]},
                           { "position": { "x": 0, "y": 35 }, "targets": [{ "type": "T1", "damage": 12 },
                                                                          {"type":"HK-Tank", "damage":20}] }]}.to_json
  end
  context 'with valid attack­mode and radars [position - target]' do
    it 'can create target selection' do
      target_selection = TargetSelection.new(@targets)
      expect(target_selection.attack_mode).to eq(["closest-first"])
      expect(target_selection.radar[0][:position].x).to eq(0)
      expect(target_selection.radar[0][:position].y).to eq(40)
      expect(target_selection.radar[1][:position].x).to eq(0)
      expect(target_selection.radar[1][:position].y).to eq(15)
      expect(target_selection.radar[0][:targets][0].type).to eq("T1")
      expect(target_selection.radar[0][:targets][0].damage).to eq(30)
      expect(target_selection.radar[0][:targets][1].type).to eq("HK-Tank")
      expect(target_selection.radar[0][:targets][1].damage).to eq(80)
      expect(target_selection.radar[0][:targets][2].type).to eq("Human")
      expect(target_selection.radar[0][:targets][2].damage).to eq(0)
    end

    it 'can order by position ASC' do
      target_selection = TargetSelection.new(@targets)
      target_selection.order_by_position
      expect(target_selection.radar[0][:position].x).to eq(0)
      expect(target_selection.radar[0][:position].y).to eq(15)
    end

    it 'can order by position DESC' do
      target_selection = TargetSelection.new(@targets)
      target_selection.order_by_position("DESC")
      expect(target_selection.radar[0][:position].x).to eq(0)
      expect(target_selection.radar[0][:position].y).to eq(60)
    end

    it 'can avoid human' do
      target_selection = TargetSelection.new(@targets)
      target_selection.avoid_cross_fire
      target_selection.radar.each do |position_target|
        targets = position_target[:targets]
        targets.each do |target|
          expect(target.type).not_to eq("Human")
        end
      end
    end

    it 'Priorize­t­x' do
      target_selection = TargetSelection.new(@targets)
      target_selection.priroize_t_x
      expect(target_selection.radar[0][:position].x).to eq(0)
      expect(target_selection.radar[0][:position].y).to eq(60)
    end
  end
end
