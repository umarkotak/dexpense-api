class PingController < ApplicationController
  def index
    render status: 200, json: {}
  end
end
