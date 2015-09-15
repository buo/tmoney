module Tmoney
  class Transaction
    attr_accessor :datetime, :category, :payee, :amount

    def to_s
      "#{@datetime.strftime('%Y-%m-%d %H:%M:%S')} #{@category} #{@payee} #{@amount}"
    end
  end
end
