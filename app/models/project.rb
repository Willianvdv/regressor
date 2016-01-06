class Project < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :results
  belongs_to :creator, class_name: 'User'

  def example_names
    results \
      .select(:example_name)
      .distinct(:example_name)
      .pluck(:example_name)
  end

  def created_by?(user)
    creator == user
  end
end
