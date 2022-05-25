module Alami
  # sample jsessionid = F3FFFF1ED1A3AE3ED5555AF45FDD6C051DBA5A59948E549E398FB8B6EC7C0FE5B70B8C6AF373A811A3DF4CEA9EA8707518E6286CEEB3140DFB59FB2DA25AB9F9
  class Login < BaseService
    def initialize(jsessionid, username, password)
      @jsessionid = jsessionid
      @username = username
      @password = password
    end

    def call
      response = Faraday.new(
        url: 'https://p2p.alamisharia.co.id',
        headers: {
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
      ).post('/login-ajax', {
        username: @username,
        password: @password,
      })

      {
        success: response.success?,
        jsessionid: @jsessionid
      }
    end
  end
end
