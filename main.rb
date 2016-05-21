  # CARD_TYPE_BY_REGEX = {
  #   /^3[47][0-9]{13}$/           => :amex,
  #   /^6011[0-9]{12}$/            => :discover,
  #   /^5[1-5][0-9]{14}$/         => :mc,
  #    => Visa
  # }
module CreditCards
  class Factory
    def initialize(cc_number)
      @cc_number = cc_number
    end

    def call
      visa = Visa.new(cc_number)
      if visa.plausible?
        visa
      else
        Unknown.new(cc_number)
      end
    end

    private
    attr_reader :cc_number
  end

  # TODO: composition over inheritance
  class AbstractCreditCard
    def initialize(cc_number)
      @cc_number = cc_number.to_s
    end

    def plausible?
      !!(self.class.reg_exp =~ cc_number)
    end

    def name
      self.class.name.sub(/\A\w+::/, '')
    end

    private
    attr_reader :cc_number

    def self.reg_exp
      fail NotImplementedError
    end
  end

  class Unknown < AbstractCreditCard
    def plausible?
      false
    end
    def name
      'Unknown'
    end
  end

  class Visa < AbstractCreditCard
    def self.reg_exp
      /^4[0-9]{12}(?:[0-9]{3})?$/
    end
  end
end



RSpec.describe CreditCards::Factory do
  subject { described_class.new(cc_number).call }
  let(:visa_number)        { 4111111111111111 }
  let(:implausible_number) { 411111111111111 }

  context "a plausible visa number" do
    let(:cc_number) { visa_number }

    it { expect(subject.plausible?).to eq(true)  }
    it { expect(subject.name).to eq('Visa') }
  end

  context "an implausible number" do
    let(:cc_number) { implausible_number }

    it { expect(subject.plausible?).to eq(false)  }
    it { expect(subject.name).to eq('Unknown') }
  end
end
