class ResultSerializer < ActiveModel::Serializer
  attributes :example_name, :example_location

  has_many :queries, serializer: QuerySerializer
end
