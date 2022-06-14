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
        "price_change" => 0,
        "direction" => 'up',
        "price_date" => '2020-01-01',
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

      result['buyback_price'] = doc.css('section.elementor-section.elementor-top-section.elementor-element.elementor-element-c881983.elementor-section-boxed.elementor-section-height-default.elementor-section-height-default > div > div.elementor-column.elementor-col-50.elementor-top-column.elementor-element.elementor-element-5bf27b7 > div > div > div > div').text.tr('^0-9', '').to_i

      result['price_change'] = doc.css('section.elementor-section.elementor-top-section.elementor-element.elementor-element-c881983.elementor-section-boxed.elementor-section-height-default.elementor-section-height-default > div > div.elementor-column.elementor-col-50.elementor-top-column.elementor-element.elementor-element-db6cb52 > div > div > div > p:nth-child(2) > strong').text.tr('^0-9', '').to_i

      result['price_date'] = doc.css('section.elementor-section.elementor-top-section.elementor-element.elementor-element-c881983.elementor-section-boxed.elementor-section-height-default.elementor-section-height-default > div > div.elementor-column.elementor-col-50.elementor-top-column.elementor-element.elementor-element-db6cb52 > div > div > div > p:nth-child(1) > strong').text

      result['direction'] = doc.css('section.elementor-section.elementor-top-section.elementor-element.elementor-element-c881983.elementor-section-boxed.elementor-section-height-default.elementor-section-height-default > div > div.elementor-column.elementor-col-50.elementor-top-column.elementor-element.elementor-element-db6cb52 > div > div > div > p:nth-child(2) > strong').text.include?('△') ? 'up' : 'down'

      result
    end
  end
end
