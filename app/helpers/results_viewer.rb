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
