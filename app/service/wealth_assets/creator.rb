module WealthAssets
  class Creator < BaseService
    def initialize(account, params)
      @account = account
      @params = params.permit(
        :time_zone, :now_utc, :now_local,
        :group_id, :name, :description, :sub_description, :amount, :amount_unit,
        :quantity, :price, :category, :sub_category, :transaction_at, :for_sale,
        :sell_price, :cod_only, :cod_place, :cod_place_description, :deleted_at,
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
      @params[:transaction_at] = @params[:now_utc] unless @params[:transaction_at].to_s.present?
    end

    def execute_logic
      selected_category = Const::WEALTH_ASSET_RULES_MAP[@params[:category]].with_indifferent_access
      raise "400 || Invalid category" unless selected_category.present?
      amount = selected_category["sub_categories_map"][@params[:sub_category]]["amount"]
      amount_unit = selected_category["sub_categories_map"][@params[:sub_category]]["unit"]

      wealth_asset = WealthAsset.create!({
        account_id: @account.id,
        group_id: group.id,
        name: @params[:name],
        description: @params[:description],
        sub_description: @params[:sub_description],
        amount: amount,
        amount_unit:amount_unit,
        quantity: @params[:quantity],
        price: @params[:price],
        category: @params[:category],
        sub_category: @params[:sub_category],
        transaction_at: @params[:transaction_at],

        for_sale: @params[:for_sale],
        sell_price: @params[:sell_price],
        cod_only: @params[:cod_only],
        cod_place: @params[:cod_place],
        cod_place_description: @params[:cod_place_description],
      })

      @result = wealth_asset
    end

    def group
      @group ||= Group.find(@params[:group_id])
    end
  end
end
