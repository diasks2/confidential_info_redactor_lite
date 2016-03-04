module ConfidentialInfoRedactorLite
  class Hyperlink

    # Rubular: http://rubular.com/r/fXa4lp0gfS
    HYPERLINK_REGEX = /(http|https|www)(\.|:)/

    def replace(text)
      text.split(/\s+/).map { |token| text = text.gsub(/#{Regexp.escape(token.gsub(/\.\z/, ''))}/, ' <redacted hyperlink> ') if !(token !~ HYPERLINK_REGEX) }
      text
    end
  end
end
