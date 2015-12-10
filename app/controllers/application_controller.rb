class ApplicationController < ActionController::Base
  def serialize(things)
    ActiveModel::ArraySerializer.new things
  end
end
