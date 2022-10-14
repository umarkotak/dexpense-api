require 'open-uri'

module Alami
  class FundingList < BaseService
    def initialize(jsessionid)
      @jsessionid = jsessionid
    end

    def call
      begin
        html = URI.open('https://p2p.alamisharia.co.id/funder/dashboard',
          {
            'authority' => 'p2p.alamisharia.co.id',
            'referer' => 'https://p2p.alamisharia.co.id/',
            'cookie' => [
              "JSESSIONID=#{@jsessionid}",
              '_ga_RGECP19CDK=GS1.1.1652850636.1.1.1652850813.32',
              '_gcl_au=1.1.1974854867.1652850814',
              '_ga=GA1.3.744881464.1652850814',
              '_gid=GA1.3.379824038.1652850814',
              '_fbp=fb.2.1652850814045.554614945',
            ].join('; ')
          }
        )
      rescue RuntimeError
        # delete jsessionid cache
        return {
          success: false,
          err_code: 'ALAMI_API_FAILURE',
          company_items: []
        }
      end

      doc = Nokogiri::HTML(html)

      company_items = []

      doc.css('div.company-item.company-item-list').each do |company_item|
        company_items << {
          image_url: '',
          code: company_item.css('div.company-name div.row div.col-sm-6 span.d-block.text-uppercase').text,
          category: company_item.css('div.company-name div.row div.col-sm-6 span:nth-child(2)').text.strip,
          amount: company_item.css('div.company-detail div.row:nth-child(2) div.col-2 strong.convertmoneylong').text,
          ujrah: company_item.css('div.company-detail.d-none.d-lg-block > div:nth-child(1) > div > div.row.mt-4.text-alfa.detail-data.justify-content-between > div:nth-child(2) > strong').text,
          ujrah_per_tenor: '',
          deadline_date: '',
          rating: '',
          progress: company_item.css('div.company-detail.d-none.d-lg-block > div:nth-child(2) > div > div.row > div:nth-child(1) > span > strong').text,
          available_amount: company_item.css('div.company-detail.d-none.d-lg-block > div:nth-child(2) > div > div.row > div:nth-child(3) > span > strong').text,
          tenor: '',
          detail_link: "https://p2p.alamisharia.co.id/" + company_item.css('div.company-detail.d-none.d-lg-block > div:nth-child(1) > div > div:nth-child(1) > div.col-sm-6.text-right > a').attr('href').value
        }
      end

      {
        success: true,
        err_code: '',
        company_items: company_items
      }
    end
  end
end
