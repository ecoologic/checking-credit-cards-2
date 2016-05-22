require 'spec_helper'

RSpec.describe CreditCardConsole do
  subject { described_class.new(read_strategy: read_strategy, write_strategy: write_strategy) }
  let(:buffer) { [] }
  let(:write_strategy) { ->(*args) { buffer.concat args } }

  describe '#start' do
    context "when I enter a visa valid number" do
      let :read_strategy do
        double(:read_strategy).tap do |strategy|
          allow(strategy)
            .to receive(:call)
            .and_return("411 11 11 111 111 111", '')
        end
      end

      it "prints the details" do
        subject.start
        expect(buffer).to include("VISA: 4111 1111 1111 1111 (VALID)")
      end
    end
  end
end
