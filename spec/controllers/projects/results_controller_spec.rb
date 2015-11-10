require 'rails_helper'

RSpec.describe ResultsController, :type => :controller do
  let(:body_json) { JSON.parse subject.body }
  let(:project) { create :project }

  describe '.create' do
    let(:compare_with_latest_of_tag) { nil }

    let(:params) do
      {
        "tag" => "pull-request-1",
        "compare_with_latest_of_tag" => compare_with_latest_of_tag,
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

    subject { post :create, params.merge(project_id: project.id) }

    it 'succeeds' do
      expect(subject).to have_http_status :success
    end

    it 'creates two results' do
      expect { subject }.to change { Result.count }.by(2)

      expect(Result.all.map(&:tag).uniq).to eq ['pull-request-1']
    end

    context 'providing compare_with_latest_of_tag' do
      let(:compare_with_latest_of_tag) { 'pull-request-1' }

      it 'only compares with the provided tag' do
        old_result = create :result,
          project: project,
          tag: 'pull-request-1',
          example_name: 'user change user version 7 uses the correct timestamp'
        create :query, result: old_result, statement: 'select * from users'

        old_result = create :result,
          project: project,
          tag: 'ramspull-request-2',
          example_name: 'user change user version 7 uses the correct timestamp'

        create :query, result: old_result, statement: 'delete from users limit 1'

        expected_result = [{
          "example_name" => "user change user version 7 uses the correct timestamp",
          "example_location" => "spec/integration/users/user_spec.rb",
          "queries_that_got_added"=>["select * from teams where id in (?)"],
          "queries_that_got_removed"=>[],
        }]

        expect(subject).to have_http_status :success
        expect(body_json).to eq "results" => expected_result
      end
    end

    context 'with old queries' do
      it do
        old_result_not_used_for_comparison = create :result,
          project: project,
          tag: 'pull-request-1',
          example_name: 'user change user version 7 uses the correct timestamp'
        create :query, result: old_result_not_used_for_comparison, statement: 'insert into users'

        old_result_used_for_comparison = create :result,
          project: project,
          tag: 'pull-request-2',
          example_name: 'user change user version 7 uses the correct timestamp'

        create :query, result: old_result_used_for_comparison, statement: 'select * from users'
        create :query, result: old_result_used_for_comparison, statement: 'delete * from users'

        expected_result = [{
          "example_name" => "user change user version 7 uses the correct timestamp",
          "example_location" => "spec/integration/users/user_spec.rb",
          "queries_that_got_added"=>["select * from teams where id in (?)"],
          "queries_that_got_removed"=>["delete * from users"],
        }]

        expect(subject).to have_http_status :success
        expect(body_json).to eq "results" => expected_result
      end

      context 'where the same query is used multiple times' do
        it 'mentions the query twice' do
          old_result = create :result,
            project: project,
            tag: 'pull-request-1',
            example_name: 'user change user version 7 uses the correct timestamp'

          create :query, result: old_result, statement: 'select * from users'
          create :query, result: old_result, statement: 'select * from users'
          create :query, result: old_result, statement: 'select * from users'
          create :query, result: old_result, statement: 'select * from teams where id in (?)'

          expected_result = [{
            "example_name" => "user change user version 7 uses the correct timestamp",
            "example_location" => "spec/integration/users/user_spec.rb",
            "queries_that_got_added"=>[
            ],
            "queries_that_got_removed"=>[
              'select * from users',
              'select * from users',
            ],
          }]

          expect(subject).to have_http_status :success
          expect(body_json).to eq "results" => expected_result
        end
      end
    end

    describe 'without project no access' do
      it do
        expect { post(:create, params) }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe '.index' do
    subject { get :index, project_id: project.id }

    xit do
      result = create :result
      create :query, result: result
      create :query, result: result

      expect(subject).to have_http_status :success
      expect(body_json).to eq(
        "Users change reputation version 1 uses the correct timestamp" => [
          {
            "statement"=>"SELECT users.* FROM users WHERE id = 1"
          },
          {
            "statement"=>"SELECT users.* FROM users WHERE id = 2"
          }
        ]
      )
    end
  end
end
