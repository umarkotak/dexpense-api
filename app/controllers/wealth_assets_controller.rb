class WealthAssetsController < ApiController
  def categories
    render_response(data: Const.wealth_asset_to_arr)
  end

  def index
    verify_account
    service = WealthAssets::Index.new(@account, params)
    service.call
    render_response(data: service.result)
  end

  def create
    verify_account
    service = WealthAssets::Creator.new(@account, params)
    service.call
    render_response(data: service.result)
  end

  def delete
    # TODO: Implement logic
    verify_account
    service = WealthAssets::Deletor.new(@account, params)
    service.call
    render_response(data: service.result)
  end

  def dashboard
    # TODO: Implement logic
    verify_account
    service = WealthAssets::Index.new(@account, params)
    service.call
    render_response(data: service.result)
  end

  def groupped
    # TODO: Implement logic
    verify_account
    service = WealthAssets::IndexGroupped.new(@account, params)
    service.call
    render_response(data: service.result)
  end
end
