class ResultsViewer
  def initialize(results)
    @results = results
  end

  def each_with_maybe_previous
    previous = nil
    results.each do |current|
      query_change = if previous
        previous.queries_count - current.queries_count
      else
        0
      end

      yield(previous, current, query_change)
      previous = current
    end
  end

  private

  attr_reader :results
end
