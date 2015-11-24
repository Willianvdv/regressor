class ResultsComper
  attr_reader :left
  attr_reader :right

  def initialize(left, right)
    @left = left
    @right = right
  end

  def diffy
    Diffy::Diff.new(
      left.queries.map(&:statement).join("\n"),
      right.queries.map(&:statement).join("\n"),
    ).to_s(:html)
  end
end
