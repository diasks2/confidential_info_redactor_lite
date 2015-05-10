module ConfidentialInfoRedactorLite
  class Hyperlink

    # Rubular: http://rubular.com/r/fXa4lp0gfS
    HYPERLINK_REGEX = /(http|https|www)(\.|:)/

    attr_reader :string
    def initialize(string:)
      @string = string
    end

    def replace
      new_string = string.dup
      string.split(/\s+/).each do |token|
        new_string = new_string.gsub(/#{Regexp.escape(token.gsub(/\.\z/, ''))}/, ' <redacted hyperlink> ') if !(token !~ HYPERLINK_REGEX)
      end
      new_string
    end
  end
end
