class AccountsController < ApplicationController
  def register
    service = Accounts::Register.new(params)
    service.call

    render_response(
      error: service.formatted_error,
      data: service.result
    )
  end
end
