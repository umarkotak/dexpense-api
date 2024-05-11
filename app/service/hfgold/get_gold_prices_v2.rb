require 'open-uri'

module Hfgold
  class GetGoldPricesV2 < BaseService
    def initialize
    end

    def call
      result = {
        "price_source": 'https://antaremas.com',
        "prices" => {},
        "buyback_price" => 0,
        "price_change" => 0,
        "direction" => 'up',
        "price_date" => '2020-01-01',
      }

      begin
        html = URI.open('https://antaremas.com', {
          'authority' => 'antaremas.com',
        })
      rescue RuntimeError
        return result
      end

      doc = Nokogiri::HTML(html)

      doc.css('table').first.css("tr").each do |table_row|
        next unless table_row.css('td').present?

        size = table_row.css('td')[0].text.to_f
        price = table_row.css('td')[1].text.tr('^0-9', '').to_i

        result["prices"]["#{size}".sub('.0', '')] = {
          size: size, unit: "gram", price: price
        }
      end

      buyback_prices_raw = doc.xpath('/html/body/div[2]/div[3]/div/div[1]/div[1]/div/div[4]/div/p').text

      buyback_price_breakdown = buyback_prices_raw.split('/gram').map do |one_price|
        tmp1 = one_price.to_s.downcase.split('rp')
        res = nil
        if tmp1.length > 1
          res = tmp1.last.tr('^0-9', '').to_i
        end
        res
      end.compact

      result['buyback_price'] = buyback_price_breakdown.first

      result['price_change'] = doc.css('section.elementor-section.elementor-top-section.elementor-element.elementor-element-c881983.elementor-section-boxed.elementor-section-height-default.elementor-section-height-default > div > div.elementor-column.elementor-col-50.elementor-top-column.elementor-element.elementor-element-db6cb52 > div > div > div > p:nth-child(2) > strong').text.tr('^0-9', '').to_i

      result['price_date'] = doc.css('section.elementor-section.elementor-top-section.elementor-element.elementor-element-c881983.elementor-section-boxed.elementor-section-height-default.elementor-section-height-default > div > div.elementor-column.elementor-col-50.elementor-top-column.elementor-element.elementor-element-db6cb52 > div > div > div > p:nth-child(1) > strong').text

      result['direction'] = doc.css('section.elementor-section.elementor-top-section.elementor-element.elementor-element-c881983.elementor-section-boxed.elementor-section-height-default.elementor-section-height-default > div > div.elementor-column.elementor-col-50.elementor-top-column.elementor-element.elementor-element-db6cb52 > div > div > div > p:nth-child(2) > strong').text.include?('△') ? 'up' : 'down'

      result
    end
  end
end
