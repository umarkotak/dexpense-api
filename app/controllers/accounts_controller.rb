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

  def profile
    verify_account
    result = Serializer::Accounts::Profile.new(@account).call
    render_response(data: result)
  end
end
