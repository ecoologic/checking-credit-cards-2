require 'ostruct'
require 'pry'

class CreditCard
  ALL = [
    OpenStruct.new(name: "Visa", reg_exp: /^4[0-9]{12}(?:[0-9]{3})?$/),
    OpenStruct.new(name: "Master Card", reg_exp: /^5[1-5][0-9]{14}$/)
  ]
  UNKNOWN = OpenStruct.new(name: "Unknown")

  def initialize(cc_number)
    @cc_number = cc_number.to_s
  end

  def plausible?
    !!(provider.reg_exp =~ cc_number)
  end

  def name
    provider.name
  end

  private
  attr_reader :cc_number

  def provider
    ALL.detect { |p| cc_number =~ p.reg_exp } || UNKNOWN
  end
end

RSpec.configure { |c| c.expect_with :rspec }
RSpec.describe CreditCard do
  subject { described_class.new(cc_number) }
  let(:visa_number)        { 4111111111111111 }
  let(:master_card_number) { 5105105105105106 }
  let(:implausible_number) { 411111111111111 }

  context "a plausible Visa number" do
    let(:cc_number) { visa_number }

    it { expect(subject.plausible?).to eq(true)  }
    it { expect(subject.name).to eq('Visa') }
  end

  context "a plausible Master Card number" do
    let(:cc_number) { master_card_number }

    it { expect(subject.plausible?).to eq(true)  }
    it { expect(subject.name).to eq('Master Card') }
  end

  context "an implausible number" do
    let(:cc_number) { implausible_number }

    it { expect(subject.plausible?).to eq(false)  }
    it { expect(subject.name).to eq('Unknown') }
  end
end
