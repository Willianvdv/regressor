module Api
  class ResultsComper
    attr_reader :project, :left_tag, :right_tag

    def initialize(project, left_tag, right_tag)
      @project = project
      @left_tag = left_tag
      @right_tag = right_tag
    end

    def comparison
      results_left.map do |left_result|
        right_result = right_result_for left_result
        next unless right_result.present?

        left_queries = queries_for left_result
        right_queries = queries_for right_result

        queries_that_got_added = array_diff left_queries, right_queries
        queries_that_got_removed = array_diff right_queries, left_queries

        next if queries_that_got_added.empty? && queries_that_got_removed.empty?

        format_comparison(left_result, queries_that_got_added, queries_that_got_removed)
      end.compact
    end

    def comparison_in_markdown
      <<-ENDMARKDOWN
      Results:

      #{comparison.map { |result| result_to_markdown result }.join("\n")}
      ENDMARKDOWN
    end

    private

    def result_to_markdown(result)
      header = "* #{result['example_name']} (#{result['example_location']})"

      markdown = <<-ENDMARKDOWN
        * Queries that got added:
          #{array_to_markdown_list(result['queries_that_got_added'])}
        * Queries that got removed:
          #{array_to_markdown_list(result['queries_that_got_removed'])}
      ENDMARKDOWN

      header + "\n" + markdown.indent(2)
    end

    def array_to_markdown_list(arr)
      arr.map do |elem|
        "* #{elem}"
      end.join("\n")
    end

    def results_left
      project.results.where tag: left_tag
    end

    def right_result_for(left_result)
      project.results.where(
        tag: right_tag,
        example_name: left_result.example_name
      ).last
    end

    def queries_for(result)
      result.queries.order(:id).map(&:statement)
    end

    def array_diff(a, b)
      dup_b = b.dup
      a.reject do |item|
        b_index = dup_b.index(item)
        next false unless b_index
        dup_b.delete_at b_index
      end
    end

    def format_comparison(left_result, queries_that_got_added, queries_that_got_removed)
      {
        "example_name" => left_result.example_name,
        "example_location" => left_result.example_location,
        "queries_that_got_added" => queries_that_got_added,
        "queries_that_got_removed" => queries_that_got_removed,
      }
    end
  end
end
