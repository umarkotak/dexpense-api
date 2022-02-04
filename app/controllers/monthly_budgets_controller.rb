class MonthlyBudgetsController < ApiController
  def index_current
    verify_account
    service = MonthlyBudgets::IndexCurrent.new(@account, params)
    service.call
    render_response(data: service.result)
  end

  def index
  end

  def create
  end

  def edit
  end

  def delete
  end
end
