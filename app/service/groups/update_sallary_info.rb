module Groups
  class UpdateSallaryInfo < BaseService
    def initialize(account, params)
      @account = account
      @params = params.permit(:group_id, :payout_date, :monthly_sallary)
    end

    def call
      validates
      initialize_default_value
      execute_logic
      @result = @group
    end

    private

    def validates
      group
      return if group.account_id == @account.id
      raise "403 || Forbidden access to group"
    end

    def initialize_default_value
    end

    def execute_logic
      group.update!(
        payout_date: @params[:payout_date].to_s,
        monthly_sallary: @params[:monthly_sallary].to_i
      )
    end

    def group
      @group ||= Group.find(@params[:group_id])
    end
  end
end
