module V1
  class ApplicationSerializer < ActiveModel::Serializer
    self.config.adapter = :json
  end
end
