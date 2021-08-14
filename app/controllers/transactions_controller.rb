class TransactionsController < ApiController
  def index
  end

  def create
    verify_account
    service = Transactions::Creator.new(@account, params)
    service.call
    render_response(data: service.result)
  end
end
