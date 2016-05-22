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
end
