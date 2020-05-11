require 'rails_helper'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

RSpec.describe RadarController, type: :controller do
  before(:each) do
    @targets = {"attack-mode":["closest-first"],
                                    "radar":[{"position":{"x":0,"y":40},
                                              "targets":[{"type":"T1","damage":30},
                                                          {"type":"T-X","damage":80},
                                                          {"type": "Human"}]},
                                              {"position":{"x":0,"y":60},
                                              "targets":[{"type":"T-X","damage":80}]}]}
  end
  describe 'TargetSelection GET #root', type: :controller do
    it 'returns target selected' do
      post :target_selected, params: @targets
      expect(response.status).to eq 200
      hash_body = JSON.parse(response.body)
      expect(hash_body['position']["x"]).to eq(0)
      expect(hash_body['position']["y"]).to eq(40)
      expect(hash_body['targets']).to match_array(["T-X", "T1"])
    end
  end
end