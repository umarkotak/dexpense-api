class TransactionsController < ApiController
  def index
    verify_account
    service = Transactions::Index.new(@account, params)
    service.call
    transactions = service.result
    results = Serializer::Transactions::Index.new(transactions).call
    render_response(data: results)
  end

  def create
    verify_account
    service = Transactions::Creator.new(@account, params)
    service.call
    render_response(data: service.result)
  end

  def edit
    verify_account
    service = Transactions::Editor.new(@account, params)
    service.call
    render_response(data: service.result)
  end

  def delete
    verify_account
    service = Transactions::Deletor.new(@account, params)
    service.call
    render_response(data: service.result)
  end

  def transfer
    verify_account
  end
end
