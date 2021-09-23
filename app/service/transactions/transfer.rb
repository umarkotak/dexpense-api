module Transactions
  class Transfer < BaseService
    def initialize(account, params)
      @account = account
      @params = params.permit(
        :category, :amount, :direction_type, :group_wallet_id, :name, :description,
        :note, :transaction_at, :target_group_wallet_id, :transfer_fee
      )
      @transfer_group = SecureRandom.hex(7)
    end

    def call
      validates
      execute_logic
      @result = @transaction
    end

    private

    def validates
      allowed_wallet

      @transfer_name = "from: #{group_wallet.name}, to: #{target_group_wallet.name}"

      @source_transaction = Transaction.new(source_transaction_params)
      @source_transaction.validate!

      @target_transaction = Transaction.new(target_transaction_params)
      @target_transaction.validate!

      @fee_transactionn = Transaction.new(fee_transaction_params)
      @fee_transactionn.validate!
    end

    def allowed_wallet
      group_account = group_wallet.group.group_accounts.find_by(account_id: @account.id)
      raise "400 || Invalid wallet" if !group_account.present?
      raise "400 || Wallet not belong to same group" if target_group_wallet.group_id != group_wallet.group_id
    end

    def execute_logic
      ActiveRecord::Base.transaction do
        @source_transaction.save!
        @target_transaction.save!
        @fee_transactionn.save! if params[:transfer_fee].to_i > 0
        process_balance
      end
    end

    def process_balance
      group_wallet.amount -= @params[:amount].to_i
      group_wallet.amount -= @params[:transfer_fee].to_i
      target_group_wallet.amount += @params[:amount].to_i

      group_wallet.save!
      target_group_wallet.save!
    end

    def source_transaction_params
      {
        account_id: @account.id,
        group_id: group.id,
        group_wallet_id: group_wallet.id,
        category: "transfer",
        amount: @params[:amount],
        direction_type: "outcome",
        transaction_at: @params[:transaction_at] || Time.now(),
        name: @transfer_name,
        description: @params[:description],
        note: "Transfer group #{@transfer_group}",
      }
    end

    def target_transaction_params
      {
        account_id: @account.id,
        group_id: group.id,
        group_wallet_id: target_group_wallet.id,
        category: "transfer",
        amount: @params[:amount],
        direction_type: "income",
        transaction_at: @params[:transaction_at] || Time.now(),
        name: @transfer_name,
        description: @params[:description],
        note: "Transfer group #{@transfer_group}",
      }
    end

    def fee_transaction_params
      {
        account_id: @account.id,
        group_id: group.id,
        group_wallet_id: group_wallet.id,
        category: "admin_fee",
        amount: @params[:transfer_fee],
        direction_type: "outcome",
        transaction_at: @params[:transaction_at] || Time.now(),
        name: "transfer fee",
        description: "",
        note: "Transfer group #{@transfer_group}",
      }
    end

    def group_wallet
      @group_wallet ||= GroupWallet.find(@params[:group_wallet_id])
    end

    def target_group_wallet
      @target_group_wallet ||= GroupWallet.find(@params[:target_group_wallet_id])
    end

    def group
      @group ||= group_wallet.group
    end
  end
end
