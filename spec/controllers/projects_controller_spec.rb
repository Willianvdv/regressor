require 'rails_helper'

describe ProjectsController, type: :controller do
  let(:project) { create :project }

  before { sign_in :user, project.creator }

  shared_examples 'authentication' do
    context 'not singed in' do
      before { sign_out :user }

      it 'can not access the action' do
        is_expected.not_to have_http_status :ok
      end
    end
  end

  describe '.index' do
    subject { get :index }

    it 'renders the project index page' do
      is_expected.to have_http_status :ok
    end

    include_examples 'authentication'
  end

  describe '.show' do
    subject { get :show, id: project.id }

    it 'renders the project show page' do
      is_expected.to have_http_status :ok
    end

    context 'when somebody else is the owner' do
      it 'renders the project show page' do
        somebody_elses_project = create :project
        somebody_elses_project.users << project.creator

        expect(get :show, id: somebody_elses_project.id).to have_http_status :ok
      end
    end

    include_examples 'authentication'
  end

  describe '.add_user' do

    it 'adds the user to the project' do
      new_user = create :user
      expect(project.reload.users).to match_array [project.creator]

      post :add_user,
        id: project.id,
        new_user_email: new_user.email

      expect(project.reload.users).to match_array [project.creator, new_user]
    end

    it 'does nothing if the user is already a member' do
      expect(project.reload.users).to match_array [project.creator]

      expect do
        post :add_user,
          id: project.id,
          new_user_email: project.creator.email
      end.to raise_error

      expect(project.reload.users).to match_array [project.creator]
    end
  end
end
