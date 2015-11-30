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

  describe '.compare_view' do
    it 'shows the differences between the queries two results' do
      project = create :project
      left = create :result, project: project
      right = create :result, project: project

      sign_in project.user
      get :compare_view, result_id_left: left.id, result_id_right: right.id

      expect(response).to have_http_status :ok
    end
  end

  describe '.index' do
    it 'fetches a result based on id' do
      project = create :project
      left = create :result, project: project

      sign_in project.user
      get :index, id: left.id

      expect(response).to have_http_status :ok
    end
  end
end
