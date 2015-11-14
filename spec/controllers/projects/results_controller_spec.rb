require 'rails_helper'

RSpec.describe ResultsController, :type => :controller do
  let(:body_json) { JSON.parse subject.body }
  let(:project) { create :project }

  describe '.create' do
    let(:compare_with_latest_of_tag) { nil }

    let(:result_params) do
      {
        "tag" => "pull-request-1",
        "result_data" => [
          {
            "example_location" => "spec/integration/users/user_spec.rb",
            "example_name" => "user change user version 7 uses the correct timestamp",
            "queries" => [
              'select * from users',
              'select * from teams where id in (?)'
            ],
          },
          {
            "example_location" => "spec/integration/users/user_spec.rb",
            "example_name" => "user change user version 7 updates user create report rate limit privilege",
            "queries" => [
              'select * from teams where id in (?)',
              'select * from users'
            ]
          },
        ]
      }
    end

    subject { post :create, result_params.merge(project_id: project.id) }

    it { expect(subject).to have_http_status :success }

    it 'creates the results' do
      expect { subject }.to change { project.results.count }.by(2)
      result = project.results.first
      expect(result.tag).to eq 'pull-request-1'
    end

    it 'create a result even no queries are given' do
      result_params['result_data'].first.delete 'queries'
      expect { subject }.to change { Result.count }.by(2)
    end

    it 'without a project' do
      expect { post(:create, result_params) }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
