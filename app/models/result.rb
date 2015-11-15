class Result < ActiveRecord::Base
  has_many :queries
  belongs_to :project

  scope :optionally_with_tag, ->(tag) do
    tag.present? ?  where(tag: tag) : all
  end

  def queries_count
    queries.count
  end
end
