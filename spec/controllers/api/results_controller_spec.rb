require 'rails_helper'

RSpec.describe Api::ResultsController, :type => :controller do
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

    include_examples 'authenticated using api token'

    context 'authorized', :auth_using_api_token do
      let(:project) { create :project, user: user_with_api_token }

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

  describe '.compare_latest_of_tags' do
    let(:tag_left) { '123-left' }
    let(:tag_right) { 'master-right' }
    let(:project) { create :project }
    let(:shared_example_location) { 'spec/shared/example/location.rb' }
    let(:shared_example_name) { 'shared example name' }
    let(:format) { :json }

    subject do
      get :compare_latest_of_tags, format: format, project_id: project.id, left_tag: tag_left, right_tag: tag_right
    end

    let(:response_json) do
      JSON.parse subject.body
    end

    include_examples 'authenticated using api token'

    context 'authorized', :auth_using_api_token do
      let(:project) { create :project, user: user_with_api_token }

      describe 'format: json' do
        it 'compares left with right' do
          result_left = create :result,
            tag: tag_left,
            example_name: shared_example_name,
            example_location: shared_example_location,
            project: project

          result_right = create :result,
            tag: tag_right,
            example_name: shared_example_name,
            example_location: shared_example_location,
            project: project

          create :query, result: result_left, statement: 'query in both'
          create :query, result: result_right, statement: 'query in both'

          create :query, result: result_left, statement: 'new query'
          create :query, result: result_right, statement: 'removed query'

          expect(response_json).to eq 'results' => [{
            'example_name' => 'shared example name',
            'example_location' => 'spec/shared/example/location.rb',
            'queries_that_got_added' => ['new query'],
            'queries_that_got_removed' => ['removed query']
          }]
        end
      end

      describe 'format text' do
        let(:format) { :text }

        it 'compares left with right' do
          result_left = create :result,
            tag: tag_left,
            example_name: shared_example_name,
            project: project

          result_right = create :result,
            tag: tag_right,
            example_name: shared_example_name,
            project: project

          create :query, result: result_left, statement: 'query in both'
          create :query, result: result_right, statement: 'query in both'

          create :query, result: result_left, statement: 'new query'
          create :query, result: result_right, statement: 'removed query'

          expect(subject.status).to eq 200
        end
      end
    end
  end
end
