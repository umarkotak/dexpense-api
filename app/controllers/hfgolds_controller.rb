class HfgoldsController < ApiController
  def gold_prices
    render_response(
      data: Hfgold::GetGoldPrices.new.call
    )
  end
end
