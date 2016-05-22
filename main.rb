require 'luhn'
require 'ostruct'
require 'pry'

class CreditCard
  ALL = [
    OpenStruct.new(type: "Visa", reg_exp: /^4[0-9]{12}(?:[0-9]{3})?$/),
    OpenStruct.new(type: "Master Card", reg_exp: /^5[1-5][0-9]{14}$/)
  ]
  UNKNOWN = OpenStruct.new(type: "Unknown")

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

  attr_reader :number

  def provider
    ALL.detect { |p| number =~ p.reg_exp } || UNKNOWN
  end
end

RSpec.configure { |c| c.expect_with :rspec }
RSpec.describe CreditCard do
  subject { described_class.new(number) }

  let(:visa_number)                { 4111111111111111 }
  let(:master_card_number)         { 5105105105105100 }
  let(:implausible_number)         { 411111111111111 }

  context "a valid Visa number" do
    let(:number) { visa_number }

    it { expect(subject.plausible?).to eq(true)  }
    it { expect(subject.type).to eq('Visa') }
  end

  context "an invalid Visa number" do
    let(:number) { visa_number + 1 }

    it { expect(subject.plausible?).to eq(true)  }
    it { expect(subject.valid?).to eq(false)  }
    it { expect(subject.type).to eq('Visa') }
  end

  context "a valid Master Card number" do
    let(:number) { master_card_number }

    it { expect(subject.plausible?).to eq(true)  }
    it { expect(subject.valid?).to eq(true)  }
    it { expect(subject.type).to eq('Master Card') }
  end

  context "an invalid Master Card number" do
    let(:number) { master_card_number + 1 }

    it { expect(subject.plausible?).to eq(true)  }
    it { expect(subject.valid?).to eq(false)  }
    it { expect(subject.type).to eq('Master Card') }
  end

  context "an implausible number" do
    let(:number) { implausible_number }

    it { expect(subject.plausible?).to eq(false)  }
    it { expect(subject.type).to eq('Unknown') }
  end
end
