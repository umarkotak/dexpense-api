module Transactions
  class Creator < BaseService
    def initialize(account, params)
      @account = account
      @params = params.permit(
        :category, :amount, :direction_type, :group_wallet_id, :name, :description, :note, :transaction_at,
        :monthly_budget_id
      )
    end

    def call
      validates
      initialize_default_value
      execute_logic
      @result = @transaction
    end

    private

    def validates
      allowed_wallet
      @transaction = Transaction.new(transaction_params)
      @transaction.validate!
    end

    def initialize_default_value
      @params[:transaction_at] = Time.zone.now unless @params[:transaction_at].to_s.present?
    end

    def allowed_wallet
      group_account = group_wallet.group.group_accounts.find_by(account_id: @account.id)
      return if group_account.present?
      raise "400 || Invalid wallet"
    end

    def execute_logic
      ActiveRecord::Base.transaction do
        @transaction.save!
        process_balance
      end
    end

    def process_balance
      if @params[:direction_type] == "income"
        group_wallet.amount += @params[:amount].to_i
      elsif @params[:direction_type] == "outcome"
        group_wallet.amount -= @params[:amount].to_i
      else
        raise "400 || Invalid direction type`"
      end
      group_wallet.save!
    end

    def transaction_params
      if monthly_budget.present?
        @params[:category] = monthly_budget.category
      end

      {
        account_id: @account.id,
        group_id: group.id,
        group_wallet_id: group_wallet.id,
        category: @params[:category],
        amount: @params[:amount],
        direction_type: @params[:direction_type],
        transaction_at: @params[:transaction_at],
        name: @params[:name],
        description: @params[:description],
        note: @params[:note],
        monthly_budget_id: @params[:monthly_budget_id],
      }
    end

    def group_wallet
      @group_wallet ||= GroupWallet.find(@params[:group_wallet_id])
    end

    def group
      @group ||= group_wallet.group
    end

    def monthly_budget
      return nil unless @params[:monthly_budget_id].present?
      @monthly_budget ||= MonthlyBudget.find(@params[:monthly_budget_id])
    end
  end
end
