module Alami
  class CompactDashboard < BaseService
    def initialize
    end

    def call
      binding.pry

      html = URI.open("https://en.wikipedia.org/wiki/Douglas_Adams")
      doc = Nokogiri::HTML(html)
    end
  end
end
