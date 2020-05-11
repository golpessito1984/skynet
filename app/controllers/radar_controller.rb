class RadarController < ApplicationController
  before_action :set_positions_targets, only: :target_selected

  def target_selected
    targets = set_positions_targets.to_h.to_json
    target_selection = TargetSelection.new(targets).select_target
    render json: target_selection, status: :ok
  end

  private

  def set_positions_targets #{"type":"T1","damage":30}
    params.permit("attack-mode" => [], "radar" => [position: {}, targets: [:type, :damage]])
  end

end