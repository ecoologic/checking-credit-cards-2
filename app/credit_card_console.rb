class CreditCardConsole
  DEFAULT_READ_STRATEGY = ->(*) { STDIN::gets.chomp }
  DEFAULT_WRITE_STRATEGY = ->(*args) { puts *args }

  def initialize(read_strategy: DEFAULT_READ_STRATEGY, write_strategy: DEFAULT_WRITE_STRATEGY)
    @read_strategy = read_strategy
    @write_strategy = write_strategy
    @credit_card_numbers = []
  end

  def start
    get_credit_card_numbers

    display_credit_cards

    say "\nBye\n"
  end

  private

  attr_reader :credit_card_numbers, :read_strategy, :write_strategy

  def get_input
    read_strategy.()
  end

  def say(*args)
    write_strategy.(*args)
  end

  def get_credit_card_numbers
    say "Enter credit card numbers, one per line, finish with an empty line"
    until (cc = get_input) == '' do
      @credit_card_numbers << cc
    end
  end

  def display_credit_cards
    say "\n*Results*\n"
    credit_card_numbers.each do |credit_card_number|
      say display_credit_card(credit_card_number)
    end
  end

  # "TYPE: NUMBERS (VALIDITY)"
  def display_credit_card(credit_card_number)
    number = credit_card_number.scan(/.{4}/).join(' ')
    cc = CreditCard.new(credit_card_number)
    validity = cc.valid? ? 'VALID' : 'INVALID'

    "#{cc.type.upcase}: #{number} (#{validity})"
  end
end
