module WealthAssets
  class Deletor < BaseService
    def initialize(account, params)
      @account = account
      @params = params.permit(
        :time_zone, :now_utc, :now_local,
        :group_id, :id,
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
      wealth_asset
      if wealth_asset.account_id != @account.id
        raise "403 || Forbidden access to asset"
      end
    end

    def initialize_default_value
    end

    def execute_logic
      wealth_asset.update!(deleted_at: Time.now)
      @result = wealth_asset
    end

    def wealth_asset
      @wealth_asset ||= WealthAsset.find_by!(id: params[:id], deleted_at: nil)
    end

    def group
      @group ||= Group.find(@params[:group_id])
    end
  end
end
