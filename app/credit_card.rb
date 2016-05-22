class CreditCard
  ALL = [
    OpenStruct.new(type: "Visa", reg_exp: /^4[0-9]{12}(?:[0-9]{3})?$/),
    OpenStruct.new(type: "Master Card", reg_exp: /^5[1-5][0-9]{14}$/)
  ]
  UNKNOWN = OpenStruct.new(type: "Unknown")

  attr_reader :number

  def initialize(number)
    @number = number.to_s.gsub ' ', ''
  end

  def plausible?
    !!(provider.reg_exp =~ number)
  end

  def valid?
    Luhn.valid?(number)
  end

  def type
    provider.type
  end

  private

  def provider
    ALL.detect { |p| number =~ p.reg_exp } || UNKNOWN
  end
end
