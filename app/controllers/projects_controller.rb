class ProjectsController < BackendController
  def new
    @project = current_user.projects.build
  end

  def create
    @project = current_user.projects.build project_params

    if @project.save
      redirect_to @project, success: 'Project created'
    else
      render :new
    end
  end

  def index
    @projects = current_user.projects
  end

  def show
    @project = current_user.projects.find params['id']
    @example_names = @project.example_names
  end

  private

  def project_params
    params.require(:project).permit(:name)
  end
end
