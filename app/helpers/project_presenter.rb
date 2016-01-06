class ProjectPresenter
  def initialize(project)
    @project = project
  end

  def method_missing(method)
    project.send(method)
  end

  def membership_name(user)
    if project.created_by? user
      "Creator"
    else
      "Member"
    end
  end

  private

  attr_reader :project
end
