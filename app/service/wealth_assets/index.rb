module WealthAssets
  class Index < BaseService
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
      wealth_assets = WealthAsset.where({
        group_id: group.id,
        deleted_at: nil,
      }).order(@params[:order])

      gold_price_data = Hfgold::GetGoldPrices.new.call
      Rails.logger.info(gold_price_data)

      formatted_wealth_assets = wealth_assets.map do |wa|
        formatted_wa = wa.attributes.to_h

        if wa.category == "gold"
          total_gram = wa.amount.to_i * wa.quantity.to_i
          formatted_wa["total_buyback_price"] = gold_price_data['buyback_price'].to_i * total_gram
          formatted_wa["profit"] = formatted_wa["total_buyback_price"] - wa.price
        end

        formatted_wa
      end

      @result = formatted_wealth_assets
    end

    def group
      @group ||= Group.find(@params[:group_id])
    end
  end
end
