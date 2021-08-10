class BaseService
  include ActiveModel::Validations

  attr_reader :params, :result

  def formatted_error
    errors.full_messages.join(', ')
  end
end
