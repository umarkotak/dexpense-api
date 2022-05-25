module Alami
  # sample jsessionid = F3FFFF1ED1A3AE3ED5555AF45FDD6C051DBA5A59948E549E398FB8B6EC7C0FE5B70B8C6AF373A811A3DF4CEA9EA8707518E6286CEEB3140DFB59FB2DA25AB9F9
  class GetSession < BaseService
    def initialize
    end

    def call
      response = Faraday.new(
        url: 'https://p2p.alamisharia.co.id',
        headers: {
          'authority' => 'p2p.alamisharia.co.id'
        }
      ).get('/')

      begin
        jsessionid = response.headers['set-cookie'].split('; ').first
        jsessionid = jsessionid.gsub('JSESSIONID=', '')
      rescue
        jsessionid = ''
      end

      {
        success: response.success?,
        jsessionid: jsessionid,
      }
    end
  end
end
