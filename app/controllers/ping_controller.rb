class PingController < ApiController
  def index
    render status: 200, json: {}
  end
end
