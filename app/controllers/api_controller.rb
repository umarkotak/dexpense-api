class ApiController < ApplicationController
  rescue_from StandardError, with: :handle_error

  def render_response(status: 200, data: {}, error: "")
    formatted_data = { data: data, error: error }
    render(status: status, json: formatted_data)
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

    render_response(status: status, error: error_message)
  end
end
