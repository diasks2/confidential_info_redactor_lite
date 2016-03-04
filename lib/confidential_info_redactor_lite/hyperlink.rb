module ConfidentialInfoRedactorLite
  class Hyperlink

    # Rubular: http://rubular.com/r/fXa4lp0gfS
    HYPERLINK_REGEX = /(http|https|www)(\.|:)/

    def replace(text)
      new_string = text
      text.split(/\s+/).each do |token|
        new_string = new_string.gsub(/#{Regexp.escape(token.gsub(/\.\z/, ''))}/, ' <redacted hyperlink> ') if !(token !~ HYPERLINK_REGEX)
      end
      new_string
    end
  end
end
