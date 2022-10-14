require 'open-uri'

module Alami
  class Bot < BaseService
    attr_reader :twilio_client

    EACH_FUNDING_INTERVAL = 10
    EACH_LOOP_INTERVAL = 60

    def initialize
      @twilio_client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_ACCOUNT_AUTH_TOKEN'])
      @send_code_log = {}
    end

    def call
      jsessionid = Alami::GetSession.new.call[:jsessionid]
      jsessionid = Alami::Login.new(jsessionid, ENV['ALAMI_EMAIL'], ENV['ALAMI_PASSWORD']).call[:jsessionid]
      puts jsessionid

      message = twilio_client.messages.create(
        body: "STARTING SCRIPT, WA OK",
        to: ENV['WA_TARGET_PHONE'],
        from: "whatsapp:+14155238886"
      )

      loop do
        puts "Checking any alami open request #{Time.now}"
        # puts "Jsession: #{jsessionid}"

        funding_list = [{
          image_url: '',
          code: '',
          category: '',
          amount: '',
          ujrah: '',
          ujrah_per_tenor: '',
          deadline_date: '',
          rating: '',
          progress: '',
          available_amount: '',
          tenor: '',
          detail_link: '',
        }]
        funding_list_data = Alami::FundingList.new(jsessionid).call
        funding_list = funding_list_data[:company_items]

        if !funding_list_data[:success] && funding_list_data[:err_code] == 'ALAMI_API_FAILURE'
          jsessionid = Alami::GetSession.new.call[:jsessionid]
          jsessionid = Alami::Login.new(jsessionid, ENV['ALAMI_EMAIL'], ENV['ALAMI_PASSWORD']).call[:jsessionid]
          puts jsessionid

          funding_list_data = Alami::FundingList.new(jsessionid).call
        end

        funding_list.each do |funding|
          if @send_code_log[funding[:code]].present?
            next
          end

          message = twilio_client.messages.create(
            body: "
*ALAMI FUNDING*
nama: #{funding[:code]}
link: #{funding[:detail_link]}
progres: #{funding[:progress]}
ujrah: #{funding[:ujrah]}
total: Rp. #{funding[:amount]}
slot: Rp. #{funding[:available_amount]}
            ",
            to: "whatsapp:+6285217251690",
            from: "whatsapp:+14155238886"
          )
          puts "message sid: #{message.sid}"

          @send_code_log[funding[:code]] = true
          puts "success sending"
          sleep(EACH_FUNDING_INTERVAL)
        end

        puts "\n"
        sleep(EACH_LOOP_INTERVAL*rand(3..4))
      end
    end
  end
end
