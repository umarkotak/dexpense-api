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
      raise "400 || Missing group" unless group.present? 
      group_account = group.group_accounts.find_by(account_id: @account.id)
      return if group_account.present?
      raise "400 || Invalid group"
    end

    def execute_logic
      @transactions = Transaction.preload(:account, :group_wallet).where(where_params).limit(@params[:limit]).offset(@params[:offset]).order(ordering)
    end

    def where_params
      {
        group_id: @params[:group_id]
      }.compact
    end

    def ordering
      "id desc"
    end

    def group
      @group ||= Group.find(@params[:group_id])
    end
  end
end
