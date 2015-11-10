class Result < ActiveRecord::Base
  has_many :queries
  belongs_to :project

  scope :optionally_with_tag, ->(tag) do
    if tag.present?
      where(tag: tag)
    else
      all
    end
  end
end
