class GroupsController < ApiController
  def invite
    verify_account
    service = Groups::Invitator.new(@account, params)
    service.call
    render_response(data: nil)
  end

  def show
    verify_account
    service = Groups::Show.new(@account, params)
    service.call
    group = service.result
    result = Serializer::Groups::Show.new(group).call
    render_response(data: result)
  end

  def create
    verify_account
    service = Groups::Creator.new(@account, params)
    service.call
    group = service.result
    result = Serializer::Groups::Show.new(group).call
    render_response(data: result)
  end
end
