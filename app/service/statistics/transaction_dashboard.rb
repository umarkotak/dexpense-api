module Statistics
  class TransactionDashboard < BaseService
    def initialize(account, params)
      @account = account
      @params = params.permit(:group_id)
      @result = {
        balance: 0,
        minus_balance: 0,
        total_income: 0,
        total_outcome: 0
      }
    end

    def call
      validates
      execute_logic
      @result
    end

    private

    def validates
      raise "400 || Missing group" unless group.present?
      group_account = group.group_accounts.find_by(account_id: @account.id)
      return if group_account.present?
      raise "400 || Invalid group"
    end

    def execute_logic
      group_wallets = GroupWallet.where(group_id: group.id)
      group_wallets.each do |group_wallet|
        if group_wallet.amount >= 0
          @result[:balance] += group_wallet.amount
        else
          @result[:minus_balance] += group_wallet.amount
        end
      end
      transaction_income = Transaction.where(group_id: group.id, direction_type: "income").sum("amount")
      @result[:total_income] = transaction_income
      transaction_outcome = Transaction.where(group_id: group.id, direction_type: "outcome").sum("amount")
      @result[:total_outcome] = transaction_outcome
    end

    def group
      @group ||= Group.find(@params[:group_id])
    end
  end
end
