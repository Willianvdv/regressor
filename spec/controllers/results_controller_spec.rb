require 'rails_helper'

RSpec.describe ResultsController, :type => :controller do
  describe '.create' do
    let(:params) do
      {
        "result_set" => [
          {
            "example_location" => "spec/integration/reputations/reputation_spec.rb",
            "example_name" => "Reputation change reputation version 7 uses the correct timestamp",
            "queries" => [
              'select * from users',
              'select * from teams where id in (?)'
            ],
          },
          {
            "example_location" => "spec/integration/reputations/reputation_spec.rb",
            "example_name" => "Reputation change reputation version 7 updates user create report rate limit privilege",
            "queries" => [
              'select * from teams where id in (?)',
              'select * from users'
            ]
          },
        ]
      }
    end

    subject { post :create, params: params }

    it do
      expect(subject).to have_http_status :success
      binding.pry
    end
  end
end
