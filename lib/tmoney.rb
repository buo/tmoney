require 'tmoney/card'
require 'tmoney/version'

require 'rest-client'
require 'nokogiri'

# Set timezone
ENV['TZ'] = 'Asia/Seoul'

module Tmoney
  class Client
    def request(method, url, params = nil)
      begin
        headers = {}
        unless @cookies.nil? or @cookies.empty?
          headers[:Cookie] = @cookies
        end
        url = "https://www.t-money.co.kr#{url}"
        resp = RestClient::Request.execute(:method => method, :url => url, :payload => params, :headers => headers)
      rescue RestClient::ExceptionWithResponse => err
        case err.response.code
        when 200
          resp = err.response
        else
          raise err
        end
      end
      resp
    end

    # 로그인
    def connect(username, password)
      params = {
        :logOut => 'N',
        :indlMbrsId => username,
        :mbrsPwd => password
      }
      resp = request(:post, '/ncs/pct/lgncent/ReadMbrsLgn.dev', params)

      # A string for use in the Cookie header, like “name1=value2; name2=value2”.
      @cookies = resp.cookie_jar.cookies.join('; ')
    end

    # 등록된 카드 현황
    def cards
      resp = request(:get, '/ncs/pct/mtmn/ReadRgtCardPrcn.dev?logOut=N')
      doc = Nokogiri::HTML(resp.body)
      results = []
      doc.css('.tb_mylist table tbody tr').each do |tr|
        card = Card.new
        card.client = self

        # 카드 구분
        card.type = tr.css('td:nth-child(1)').text.strip

        # 카드 번호. `####-####-####-####` 형태.
        card.no = tr.css('td:nth-child(2)').text.strip

        # 카드 등록일. `YYYY-MM-DD` 형태.
        card.regdate = tr.css('td:nth-child(3)').text.strip

        # 등록 서비스
        # `어`: 어린이 요금 적용
        # `청`: 청소년 요금 적용
        # `소`: 소득공제
        # `현`: 현금영수증
        # `마`: 마일리지
        # `분`: 분실/도난
        card.services = tr.css('td:nth-child(4) span').text.strip.split(//)

        results << card
      end

      results
    end
  end
end
