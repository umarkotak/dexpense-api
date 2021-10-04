class StatisticsController < ApiController
  def transactions_daily
    verify_account
    service = Statistics::TransactionDaily.new(@account, params)
    service.call
    render_response(data: service.result)
  end

  def transactions_per_category
    verify_account
    service = Statistics::TransactionPerCategory.new(@account, params)
    service.call
    render_response(data: service.result)
  end

  def transactions_dashboard
    verify_account
    service = Statistics::TransactionDashboard.new(@account, params)
    service.call
    render_response(data: service.result)
  end
end
