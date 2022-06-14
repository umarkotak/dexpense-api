require 'open-uri'

module Hfgold
  class GetGoldPrices < BaseService
    def initialize
    end

    def call
      result = {
        "price_source": 'https://muamalahemas.com',
        "prices" => {},
        "buyback_price" => 0,
        "price_date" => "2020-01-01",
      }

      begin
        html = URI.open('https://muamalahemas.com', {
          'authority' => 'muamalahemas.com',
        })
      rescue RuntimeError
        return result
      end

      doc = Nokogiri::HTML(html)

      doc.css('table#tablepress-1 tbody tr').each do |table_row|
        size = table_row.css('td.column-1').text.to_f
        price = table_row.css('td.column-2').text.tr('^0-9', '').to_i

        result["prices"]["#{size}".sub('.0', '')] = {
          size: size, unit: "gram", price: price
        }
      end

      result
    end
  end
end
