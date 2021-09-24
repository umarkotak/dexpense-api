class StatisticsController < ApiController
  def transactions_daily
    verify_account
    service = Statistics::TransactionDaily.new(@account, params)
    service.call
    render_response(data: service.result)
  end
end
