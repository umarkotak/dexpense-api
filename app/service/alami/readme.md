jsessionid = Alami::GetSession.new.call[:jsessionid]
jsessionid = Alami::Login.new(jsessionid, ENV['ALAMI_EMAIL'], ENV['ALAMI_PASSWORD']).call[:jsessionid]
funding_list = Alami::FundingList.new(jsessionid, 'umarkotak@gmail.com').call
