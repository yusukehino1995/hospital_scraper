# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Hospitals', type: :request do
  describe 'GET /hospitals' do
    it 'response success' do
      get hospitals_path
      expect(response).to have_http_status(:ok)
    end
  end
end
