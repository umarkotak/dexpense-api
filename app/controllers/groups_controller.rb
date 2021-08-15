class GroupsController < ApiController
  def invite
    verify_account
    service = Groups::Invitator.new(@account, params)
    service.call
    render_response(data: nil)
  end
end
