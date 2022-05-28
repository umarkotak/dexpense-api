class ApiController < ApplicationController
  rescue_from StandardError,
              with: :handle_error
  rescue_from ActiveRecord::RecordInvalid,
              ActiveRecord::RecordNotFound,
              with: :handle_error_bad_request

  before_action :embed_time_zone_to_params

  def render_response(status: 200, data: {}, error: "")
    formatted_data = { data: data, error: error }
    render(status: status, json: formatted_data)
  end

  def verify_account
    service = Auth::Authenticator.new(request.headers["Authorization"].to_s)
    service.call
    @account = service.result
  end

  def embed_time_zone_to_params
    params[:locale] = request.headers.fetch("Locale", "id").to_s
    params[:time_zone] = request.headers.fetch("Time-Zone", "+7").to_i
    params[:now_utc] = Time.zone.now
    params[:now_local] = params[:now_utc] + params[:time_zone].hour
  end

  private

  def handle_error(e)
    message_raw = e&.message.to_s
    error_messages = message_raw.split(" || ")
    error_status = error_messages[0].to_i
    error_message = error_messages[1].to_s

    if error_status == 0
      status = 500
      error_message = message_raw
    else
      status = error_status
    end

    ts = Time.zone.now.iso8601
    logger.error(
      "\n" \
      "[ERROR][#{ts}][START]\n" \
      "ERROR: #{message_raw}\n" \
      "#{e&.backtrace[0...5].join("\n")}" \
      "[ERROR][#{ts}][END]" \
      "\n"
    )

    formatted_error = "#{e.class.to_s.gsub("RuntimeError", "")} | #{error_message}".delete_prefix(" | ")

    render_response(status: status, error: formatted_error)
  end

  def handle_error_bad_request(e)
    raise "400 || #{e.class} | #{e&.message.to_s}"
  rescue => e
    handle_error(e)
  end
end
