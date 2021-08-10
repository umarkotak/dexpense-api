class AccountsController < ApiController
  def register
    service = Accounts::Register.new(params)
    service.call
    render_response(data: service.result)
  end

  def login
    service = Accounts::Login.new(params)
    service.call
    render_response(data: service.result)
  end
end
