class Project < ActiveRecord::Base
  belongs_to :user
  has_many :results

  def example_names
    results \
      .select(:example_name)
      .distinct(:example_name)
      .pluck(:example_name)
  end
end
