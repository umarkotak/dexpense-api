class GroupWalletsController < ApiController
  def create
    verify_account
    service = GroupWallets::Creator.new(@account, params)
    service.call
    group_wallet = service.result
    render_response(data: group_wallet)
  end

  def edit
    verify_account
    service = GroupWallets::Editor.new(@account, params)
    service.call
    group_wallet = service.result
    render_response(data: group_wallet)
  end

  def delete
    verify_account
    service = GroupWallets::Deletor.new(@account, params)
    service.call
    group_wallet = service.result
    render_response(data: group_wallet)
  end
end
