require 'csv'

class TransactionsController < ApiController
  def index
    verify_account
    service = Transactions::Index.new(@account, params)
    service.call
    transactions = service.result
    results = Serializer::Transactions::Index.new(transactions).call
    render_response(data: results)
  end

  def index_daily
    verify_account
    service = Transactions::IndexDaily.new(@account, params)
    service.call
    transactions = service.result
    results = Serializer::Transactions::IndexDaily.new(params, transactions).call
    render_response(data: results)
  end

  def index_monthly
    verify_account
    service = Transactions::IndexMonthly.new(@account, params)
    service.call
    transactions = service.result
    results = Serializer::Transactions::IndexMonthly.new(params, transactions).call
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

  def show
    verify_account
    service = Transactions::Show.new(@account, params)
    service.call
    render_response(data: service.result)
  end

  def transfer
    verify_account
    service = Transactions::Transfer.new(@account, params)
    service.call
    render_response(data: service.result)
  end

  def adjust
    verify_account
    service = Transactions::Adjust.new(@account, params)
    service.call
    render_response(data: service.result)
  end

  def download
    verify_account
    service = Transactions::Downloader.new(@account, params)
    service.call
    render(status: 200, json: service.result)
  end

  def summary
    verify_account
    service = Transactions::Summary.new(@account, params)
    service.call
    render_response(data: service.result)
  end
end
