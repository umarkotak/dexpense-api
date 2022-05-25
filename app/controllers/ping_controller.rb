class PingController < ApiController
  def index
    puts ENV['ALAMI_EMAIL']
    render_response(
      data: {
        version: 1,
        app_name: "dexpense-api"
      }
    )
  end
end
