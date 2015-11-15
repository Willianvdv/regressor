class ExamplesController < ApplicationController
  before_action :authenticate_user!

  def show
    @example = example
    @last_result_for_this_example = last_result_for_this_example
    @results_for_this_example = results_for_this_example
  end

  private

  def example_name
    params['id']
  end

  def example
    Struct.new('Example', :example_name, :example_location).new \
      last_result_for_this_example.example_name,
      last_result_for_this_example.example_location
  end

  def last_result_for_this_example
    @last_result_for_this_example ||= results_for_this_example.last
  end

  def project_id
    params['project_id']
  end

  delegate :results, to: :project

  def results_for_this_example
    results.where example_name: example_name
  end

  def project
    current_user.projects.find project_id
  end
end

