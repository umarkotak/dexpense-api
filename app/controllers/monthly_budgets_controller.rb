class MonthlyBudgetsController < ApiController
  def index_current
    verify_account
    service = MonthlyBudgets::IndexCurrent.new(@account, params)
    service.call
    render_response(data: service.result)
  end

  def index
    verify_account
    service = MonthlyBudgets::Index.new(@account, params)
    service.call
    render_response(data: service.result)
  end

  def create
    verify_account
    service = MonthlyBudgets::Creator.new(@account, params)
    service.call
    render_response(data: service.result)
  end

  def edit
  end

  def delete
  end
end
