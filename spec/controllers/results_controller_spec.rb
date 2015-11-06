require 'rails_helper'

RSpec.describe ResultsController, :type => :controller do
  describe '.create' do
    let(:params) do
      {
        "result_data" => [
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
    end
  end

  describe '.index' do
    subject { get :index }
    let(:body_json) { JSON.parse subject.body }

    it do
      result = create :result
      create :query, result: result

      results = [{
        "example_location" => result.example_location,
        "example_name" => result.example_name,
        "queries" => result.queries.map do |query|
          { "statement" => query.statement }
        end
      }]

      expect(subject).to have_http_status :success
      expect(body_json).to eq "results" => results
    end
  end
end
