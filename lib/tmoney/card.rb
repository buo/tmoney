require 'tmoney/transaction'

module Tmoney
  class Card
    attr_accessor :type, :no, :regdate, :services

    def client=(client)
      @client = client
    end

    # 사용 내역 조회
    # - 조회기간은 조회신청일(0일) 기준 D-367일 부터 D-2일 까지 가능합니다.
    # - 사용내역 조회는 홈페이지에 등록된 카드만 제공되며, 카드 등록 이후 내역부터 조회 가능합니다.
    # - 유패스카드 전환 회원의 사용내역은 2014년 10월 15일 이후부터 조회가 가능합니다.
    # - 티머니 카드가 아닌 신용카드 및 타사 선불카드의 이용내역은 제공되지 않습니다.
    # - 회원가입 이전의 사용내역을 원하시는 경우 [사용내역 신청]메뉴를 이용하시기 바랍니다.
    # - 회원가입 이전에 할인 등록된 카드는 조회하실 수 없으니 새로 등록을 하시기 바랍니다.
    def transactions
      params = {
        # 분류
        # 분류에 따라 결과 페이지 형식이 달라지므로 변경하지 않는다.
        # `ALL`: 전체
        # `USE`: 사용
        # `CHG`: 충전
        # `RY` : 환불
        :inqrDvs => 'ALL',

        # 거래내역 조회 본인 동의 여부
        # 본인은 조회 하고자 하는 해당 카드가 본인의 소유임을 확인하며, 조회된 거래내역 및 기록이
        # 제 3자 에게 유출됨으로 인하여 발생하게 되는 모든 문제에 대하여는 그 책임이 본인에게 있음을
        # 확인 합니다.
        :agrmYn => 'Y',

        # 카드 번호
        :srcPrcrNo => @no.gsub(/-/, ''),

        # 조회 기간
        # `1`: 최근 1주
        # `2`: 최근 1개월
        # `3`: 최근 3개월
        # `4`: 최근 6개월
        # `5`: 최근 1년
        :srcChcDiv => 5,

        # 조회 시작 일자. `YYYY-MM-DD` 형태
        :srcSttDt => @regdate,

        # 조회 종료 일자. `YYYY-MM-DD` 형태
        :srcEdDt => Time.new.strftime('%Y-%m-%d')
      }
      resp = @client.request(:post, '/ncs/pct/mtmn/ReadTrprInqr.dev', params)

      doc = Nokogiri::HTML(resp.body)

      results = []
      doc.css('#protable tbody tr').each do |tr|
        t = Transaction.new

        t.datetime = Time.parse(tr.css('td:nth-child(1)').text.strip)
        t.category = tr.css('td:nth-child(2)').text.strip
        t.payee = tr.css('td:nth-child(3)').text.strip
        t.amount = tr.css('td:nth-child(4)').text.gsub(/[,원]/, '').strip.to_i

        results << t
      end

      results
    end

    def to_s
      "#{@type} #{@no} #{@regdate} #{@services.join(',')}"
    end
  end
end
