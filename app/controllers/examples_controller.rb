class ExamplesController < ApplicationController
  before_action :authenticate_user!

  class ResultsViewer
    attr_reader :results

    def initialize(results)
      @results = results
    end

    def each_with_maybe_previous
      previous = nil
      results.each do |current|
        if previous
          query_change = previous.queries_count - current.queries_count
        else
          query_change = 0
        end

        yield(previous, current, query_change)
        previous = current
      end
    end
  end

  def show
    @example = example
    @results_viewer = ResultsViewer.new(results_for_this_example)

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
    @last_result_for_this_example ||= results_for_this_example.first
  end

  def project_id
    params['project_id']
  end

  delegate :results, to: :project

  def results_for_this_example
    results.where(example_name: example_name).order(created_at: :desc)
  end

  def project
    current_user.projects.find project_id
  end
end

