module WealthAssets
  class Dashboard < BaseService
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
    end

    def execute_logic
      result = {
        total_asset: 0,
        total_gold_gr: 0,
        total_gold_1yo: 0,
        total_gold_buyback: 0,
        zakat_maal_gold: 0,
      }

      summarize_asset = WealthAsset.select("
        SUM(price) AS total_price
      ").where({
        group_id: group.id,
        deleted_at: nil
      })

      if summarize_asset.size <= 0
        @result = result
        return
      end

      summarize_asset = summarize_asset[0]

      result[:total_asset] = summarize_asset.total_price

      zakat_asset = WealthAsset.select("
        SUM(price) AS total_price,
        SUM(quantity * amount) AS total_gold_gr,
        SUM(
          quantity * amount * CASE
            WHEN transaction_at <= (NOW() - interval '1 year') THEN 1
            ELSE 0
          END
        ) AS total_gold_1yo
      ").where({
        category: 'gold',
        group_id: group.id,
        deleted_at: nil
      })

      if zakat_asset.size <= 0
        @result = result
        return
      end

      zakat_asset = zakat_asset[0]

      gold_price_data = Hfgold::GetGoldPrices.new.call

      result[:total_gold_gr] = zakat_asset.total_gold_gr
      result[:total_gold_1yo] = zakat_asset.total_gold_1yo
      result[:total_gold_buyback] = zakat_asset.total_gold_1yo *  gold_price_data['buyback_price'].to_i
      if result[:total_gold_1yo] >= 80
        result[:zakat_maal_gold] = result[:total_gold_buyback] * 2.5 / 100
      end

      @result = result
    end

    def group
      @group ||= Group.find(@params[:group_id])
    end
  end
end
