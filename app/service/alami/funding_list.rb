require 'open-uri'

module Alami
  class FundingList < BaseService
    def initialize(jsessionid, username)
      @jsessionid = jsessionid
      @username = username
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
          company_items: []
        }
      end

      doc = Nokogiri::HTML(html)

      company_items = []

      doc.css('div.company-item.company-item-list').each do |company_item|
        company_items << {
          image_url: '',
          code: company_item.css('div.company-name div.row div.col-sm-6 span.d-block.text-uppercase').text,
          category: '',
          amount: '',
          ujrah: '',
          ujrah_per_tenor: '',
          deadline_date: '',
          rating: '',
          progress: '',
          available_amount: '',
          tenor: ''

        }
      end

      {
        success: true,
        company_items: company_items
      }
    end
  end
end
