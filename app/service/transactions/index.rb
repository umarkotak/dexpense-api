module Transactions
  class Index < BaseService
    def initialize(account, params)
      @account = account
      @params = params.permit(
        :limit, :offset, :group_id
      )
    end

    def call
      validates
      execute_logic
      @result = @transactions
    end

    private

    def validates
    end

    def execute_logic
      @transactions = Transaction.preload(:account).where(where_params).limit(@params[:limit]).offset(@params[:offset]).order(ordering)
    end

    def where_params
      {
        group_id: @params[:group_id]
      }.compact!
    end

    def ordering
      "id desc"
    end
  end
end
