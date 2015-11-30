class ResultsComper
  attr_reader :left
  attr_reader :right

  def initialize(left, right)
    @left = left
    @right = right
  end

  def diffy
    Diffy::Diff.new(
      result_to_statements(left),
      result_to_statements(right),
    ).to_s(:html)
  end

  private

  def result_to_statements(result)
    queries = result.queries.map(&:statement).join("\n")
    CGI::escapeHTML(queries)
  end
end
