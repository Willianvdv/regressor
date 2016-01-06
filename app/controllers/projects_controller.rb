class ProjectsController < BackendController
  def new
    @project = new_project_for current_user
  end

  def create
    @project = new_project_for(current_user)

    if @project.update(project_params)
      redirect_to @project, notice: 'Project created'
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

  def add_user
    project = current_user.projects.find params['id']
    new_user = User.find_by email: params["new_user_email"]

    if new_user.present?
      project.users << new_user
      redirect_to project, notice: "#{new_user.email} added to project"
    else
      redirect_to project, alert: "User #{params["new_user_email"]} not found"
    end
  end

  private

  def project_params
    params.require(:project).permit(:name)
  end

  def new_project_for(user)
    Project.new(creator: user, users: [user])
  end
end
