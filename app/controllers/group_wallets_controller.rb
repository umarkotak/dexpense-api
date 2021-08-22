class GroupWalletsController < ApiController
  def create
    verify_account
    service = GroupWallets::Creator.new(@account, params)
    service.call
    group_wallet = service.result
    render_response(data: group_wallet)
  end
end
