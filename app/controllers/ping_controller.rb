class PingController < ApiController
  def index
    render_response(
      data: {
        version: 1,
        app_name: "dexpense-api"
      }
    )
  end
end
