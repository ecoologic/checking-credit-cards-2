require 'spec_helper'

RSpec.describe CreditCardConsole do
  subject { described_class.new(read_strategy: read_strategy, write_strategy: write_strategy) }
  describe '#start' do
    context "when I enter a visa valid number" do
      let(:buffer) { [] }
      let(:write_strategy) { ->(*args) { buffer.concat args } }
      let(:read_strategy) { -> { @prev ? '' : (@prev = "411 11 11 111 111 111") } }

      it "prints the details" do
        subject.start
        expect(buffer).to include("VISA: 4111 1111 1111 1111 (VALID)")
      end
    end
  end
end
