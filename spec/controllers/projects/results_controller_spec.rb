require 'rails_helper'

RSpec.describe ResultsController, :type => :controller do
  let(:project) { create :project }

  describe '.compare_view' do
    it 'shows the differences between the queries two results' do
      project = create :project
      left = create :result, project: project
      right = create :result, project: project

      sign_in project.creator
      get :compare_view, result_id_left: left.id, result_id_right: right.id

      expect(response).to have_http_status :ok
    end
  end

  describe '.index' do
    it 'fetches a result based on id' do
      project = create :project
      left = create :result, project: project

      sign_in project.creator
      get :index, id: left.id

      expect(response).to have_http_status :ok
    end
  end
end
