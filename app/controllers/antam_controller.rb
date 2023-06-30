class AntamController < ApiController
  def gold_prices
    render_response(
      data: Antam::GetGoldPrices.new.call
    )
  end
end
