module WealthAssets
  class IndexGroupped < BaseService
    def initialize(account, params)
      @account = account
      @params = params.permit(
        :time_zone, :now_utc, :now_local,
        :group_id, :order,
      )
    end

    def call
      validates
      initialize_default_value
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

    def initialize_default_value
      @params[:order] = 'id desc' unless @params[:order].present?
    end

    def execute_logic
      wealth_asset_groups = WealthAsset
        .select("
          category,
          SUM(price) AS total_price,
          SUM(quantity * amount) AS total_amount,
          MAX(amount_unit) AS amount_unit
        ")
        .where({
          group_id: group.id,
          deleted_at: nil,
        })
        .group("category")

      @result = wealth_asset_groups.map do |wag|
        wagf = wag.attributes.to_h
        wagf[:title] = Const::WEALTH_ASSET_RULES_MAP[wag.category]['id'.to_sym]
        wagf
      end
    end

    def group
      @group ||= Group.find(@params[:group_id])
    end
  end
end
