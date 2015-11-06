require 'rails_helper'

RSpec.describe ResultsController, :type => :controller do
  let(:body_json) { JSON.parse subject.body }

  describe '.create' do
    let(:params) do
      {
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

    subject { post :create, params: params }

    it do
      expect(subject).to have_http_status :success
    end

    context 'with old queries' do
      it do
        old_result = create :result, example_name: 'user change user version 7 uses the correct timestamp'
        create :query, result: old_result, statement: 'select * from users'

        expected_result = [{
          "example_name" => "user change user version 7 uses the correct timestamp",
          "example_location" => "spec/integration/users/user_spec.rb",
          "queries_that_got_added"=>["select * from teams where id in (?)"],
          "queries_that_got_removed"=>[],
        }]

        expect(subject).to have_http_status :success
        expect(body_json).to eq "results" => expected_result
      end

      context 'where the same query is used multiple times' do
        xit 'mentions the query twice' do
          old_result = create :result, example_name: 'user change user version 7 uses the correct timestamp'
          create :query, result: old_result, statement: 'select * from users'
          create :query, result: old_result, statement: 'select * from users'

          expected_result = [{
            "example_name" => "user change user version 7 uses the correct timestamp",
            "example_location" => "spec/integration/users/user_spec.rb",
            "queries_that_got_added"=>[
              "select * from teams where id in (?)",
              "select * from teams where id in (?)",
            ],
            "queries_that_got_removed"=>[],
          }]

          expect(subject).to have_http_status :success
          expect(body_json).to eq "results" => expected_result
        end
      end
    end
  end

  describe '.index' do
    subject { get :index }

    it do
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
