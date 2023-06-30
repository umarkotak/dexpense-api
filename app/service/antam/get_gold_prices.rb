require 'open-uri'

# Antam::GetGoldPrices.new.call
module Antam
  class GetGoldPrices < BaseService
    def initialize
    end

    def call
      result = {
        "price_source": 'https://www.logammulia.com/id/harga-emas-hari-ini',
        "prices" => {},
        "buyback_price" => 0,
        "price_change" => 0,
        "direction" => 'up',
        "price_date" => '2020-01-01',
      }

      begin
        html = URI.open('https://www.logammulia.com/id/harga-emas-hari-ini', {
          'authority' => 'logammulia.com',
        })
      rescue RuntimeError
        return result
      end

      doc = Nokogiri::HTML(html)

      doc.css('table.table.table-bordered tr').each do |table_row|
        col_idx = 0
        size = 0

        if table_row.text.include?('Emas Batangan Gift Series')
          break
        end

        table_row.css('td').each do |table_col|
          if col_idx == 0
            size = table_col.text.tr('^0-9.', '').to_f
          elsif col_idx == 1
          elsif col_idx == 2
            result["prices"]["#{size}".sub('.0', '')] = {
              size: size, unit: "gram", price: table_col.text.tr('^0-9', '').to_i
            }
          end
          col_idx += 1
        end
      end

      begin
        bbhtml = URI.open('https://www.logammulia.com/id/sell/gold', {
          'authority' => 'logammulia.com',
        })
      rescue RuntimeError
        return result
      end

      bbdoc = Nokogiri::HTML(bbhtml)

      result['buyback_price'] = bbdoc.css('div.antam-chart div.right div.ci-child[1] span.value span.text').text.tr('^0-9', '').to_i

      result
    end
  end
end
