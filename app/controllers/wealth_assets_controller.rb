class WealthAssetsController < ApiController
  def categories
    render_response(data: Const.wealth_asset_to_arr)
  end

  def index
    verify_account
  end

  def create
    verify_account
    service = WealthAssets::Creator.new(@account, params)
    service.call
    render_response(data: service.result)
  end
end
