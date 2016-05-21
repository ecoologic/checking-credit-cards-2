module CreditCards

  class Factory
    def initialize(cc_number)
      @cc_number = cc_number
    end

    def call
      Visa.new(@cc_number)
    end
  end

  class AbstractCreditCard
    def initialize(cc_number)
      @cc_number = cc_number
    end

    def valid?
      fail NotImplementedError
    end

    def name
      self.class.name
    end

    private
    attr_reader :cc_number
  end

  class Visa < AbstractCreditCard
    def valid?
      true
    end

    def name
      "Visa"
    end
  end
end



RSpec.describe CreditCards::Factory do
  subject { described_class.new(cc_number).call }
  let(:visa_number)    { 4111111111111111 }
  let(:invalid_number) { 4111111111111112 }

  context "a valid visa number" do
    let(:cc_number) { visa_number }

    it { expect(subject.valid?).to eq(true)  }
    it { expect(subject.name).to eq('Visa') }
  end

  context "an invalid number" do
    let(:cc_number) { invalid_number }

    it { expect(subject.name).to eq('Unknown') }
  end
end
