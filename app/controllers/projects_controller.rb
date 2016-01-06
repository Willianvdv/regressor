class ProjectsController < BackendController
  def new
    @project = new_project_for current_user
  end

  def create
    @project = new_project_for(current_user)

    if @project.update(project_params)
      redirect_to @project, success: 'Project created'
    else
      render :new
    end
  end

  def index
    @projects = current_user.projects.map { |project| ProjectPresenter.new project }
  end

  def show
    @project = ProjectPresenter.new(current_user.projects.find params['id'])
    @example_names = @project.example_names
  end

  private

  def project_params
    params.require(:project).permit(:name)
  end

  def new_project_for(user)
    Project.new(creator: user, users: [user])
  end
end
