class GroupsController < ApiController
  def invite_member
    verify_account
    service = Groups::Invitator.new(@account, params)
    service.call
    render_response(data: nil)
  end

  def remove_member
    verify_account
    service = Groups::Remover.new(@account, params)
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

  def index
    verify_account
    service = Groups::Index.new(@account, params)
    service.call
    groups = service.result
    results = Serializer::Groups::Index.new(groups).call
    render_response(data: results)
  end

  def edit
    verify_account
    service = Groups::Editor.new(@account, params)
    service.call
    render_response(data: service.result)
  end

  def delete
    verify_account
    service = Groups::Deletor.new(@account, params)
    service.call
    render_response(data: service.result)
  end
end
