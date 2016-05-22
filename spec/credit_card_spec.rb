require 'spec_helper'

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

  context "The exercise test values" do
    [
      [4111111111111111,      'Visa',         true],
      [41111111111111,        'Unknown',      false],
      [4012888888881881,      'Visa',         true],
      [378282246310005,       'Amex',         true],
      [6011111111111117,      'Discover',     true],
      [5105105105105100,      'Master Card',  true],
      ['5105 1051 0510 5106', 'Master Card',  false],
      [9111111111111111,      'Unknown',      false]
    ].each do |(number, type, valid)|
      context "the credit card number #{number}" do
        subject { described_class.new(number) }
        it "is type #{type} and #{'not ' unless valid}valid" do
          expect(subject.type).to eq type
          expect(subject.valid?).to eq valid
        end
      end
    end
  end
end
