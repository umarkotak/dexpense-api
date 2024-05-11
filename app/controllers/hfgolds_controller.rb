class HfgoldsController < ApiController
  def gold_prices
    render_response(
      data: Hfgold::GetGoldPricesV2.new.call
    )
  end
end
