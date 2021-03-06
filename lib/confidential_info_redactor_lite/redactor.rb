require 'confidential_info_redactor_lite/date'
require 'confidential_info_redactor_lite/hyperlink'

module ConfidentialInfoRedactorLite
  # This class redacts various tokens from a text
  class Redactor
    # Rubular: http://rubular.com/r/OI2wQZ0KSl
    NUMBER_REGEX = /(?<=\A|\A\()[^(]?\d+((,|\.|\/)*\d)*(\D?\s|\s|[[:cntrl:]]|[[:space:]]|\.?\s|\.$|$)|(?<=[[:cntrl:]]|[[:space:]]|\s|\s\(|\s'|\s‘)[^('‘]?\d+((,|\.|\/)*\d)*\"*(?=(\D?\s|\s|[[:cntrl:]]|[[:space:]]|\.?\s|\.$|$))|(?<=\s)\d+(nd|th|st)|(?<=\s)\d+\/\d+\"*(?=\s)|(?<=\()\S{1}\d+(?=\))|(?<=\s{1})\S{1}\d+\z|^\d+$|(?<=\A|\A\(|\s|[[:cntrl:]]|[[:space:]]|\s\()[^(]?\d+((,|\.|\/)*\d)*\D{2}(?=($|\s+))|(?<=\A|[[:cntrl:]]|[[:space:]]|\s|\A\(|\s\()[^\(\s]*\d+[^\.\s\)]*(?=\z|$|\s|\.$|\.\s|\))/
    # Rubular: http://rubular.com/r/mxcj2G0Jfa
    EMAIL_REGEX = /(?<=\A|\s|\()[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+(?=\z|\s|\.|\))/i

    attr_reader :language, :email_text, :hyperlink_text, :number_text, :date_text, :token_text, :tokens, :ignore_emails, :ignore_dates, :ignore_numbers, :ignore_hyperlinks, :dow, :dow_abbr, :months, :months_abbr
    def initialize(dow:, dow_abbr:, months:, months_abbr:, **args)
      @language = args[:language] || 'en'
      @tokens = args[:tokens]
      @number_text = args[:number_text] || '<redacted number>'
      @date_text = args[:date_text] || '<redacted date>'
      @token_text = args[:token_text] || '<redacted>'
      @email_text = args[:email_text] || '<redacted email>'
      @hyperlink_text = args[:hyperlink_text] || '<redacted hyperlink>'
      @ignore_emails = args[:ignore_emails]
      @ignore_dates = args[:ignore_dates]
      @ignore_numbers = args[:ignore_numbers]
      @ignore_hyperlinks = args[:ignore_hyperlinks]
      @dow = dow
      @dow_abbr = dow_abbr
      @months = months
      @months_abbr = months_abbr
    end

    def dates(text)
      return '' if text.nil?
      redact_dates(text)
    end

    def dates_html(text)
      return [] if text.nil?
      redact_dates_html(text)
    end

    def numbers(text)
      return '' if text.nil?
      redact_numbers(text)
    end

    def numbers_html(text)
      return [] if text.nil?
      redact_numbers_html(text)
    end

    def emails(text)
      return '' if text.nil?
      redact_emails(text)
    end

    def emails_html(text)
      return [] if text.nil?
      redact_emails_html(text)
    end

    def hyperlinks(text)
      return '' if text.nil?
      redact_hyperlinks(text)
    end

    def hyperlinks_html(text)
      return [] if text.nil?
      redact_hyperlinks_html(text)
    end

    def proper_nouns(text)
      return '' if text.nil?
      redact_tokens(text)
    end

    def redact(text)
      return '' if text.nil?
      if ignore_emails
        redacted_text = text
      else
        redacted_text = redact_emails(text)
      end
      redacted_text = redact_hyperlinks(redacted_text) unless ignore_hyperlinks
      redacted_text = redact_dates(redacted_text) unless ignore_dates
      redacted_text = redact_numbers(redacted_text) unless ignore_numbers
      redact_tokens(redacted_text)
    end

    def redact_html(text)
      return [] if text.nil?
      redacted_text = redact_dates_html(text)[0]
      redacted_text = redact_emails_html(redacted_text)[0]
      redacted_text = redact_hyperlinks_html(redacted_text)[0]
      redact_numbers_html(redacted_text)[0]
    end

    private

    def redact_hyperlinks_html(txt)
      redacted_text = redact_hyperlinks(txt).gsub(/\>\s#{Regexp.escape(token_text)}\s\</, ">#{token_text}<").gsub(/\>\s#{Regexp.escape(number_text)}\s\</, ">#{number_text}<").gsub(/\>\s#{Regexp.escape(date_text)}\s\</, ">#{date_text}<").gsub(/\>\s#{Regexp.escape(email_text)}\s\</, ">#{email_text}<").gsub(/\>\s#{Regexp.escape(hyperlink_text)}\s\</, ">#{hyperlink_text}<")
      if language.eql?('ja')
        final_hyperlinks_tokens = txt.scan(/http[a-zA-Z\/\:\.\-]+|www[a-zA-Z\/\:\.\-]+/)
      else
        original_sentence_array = txt.split(' ')
        redacted_sentence_array = redacted_text.split(' ')
        diff = original_sentence_array - redacted_sentence_array
        final_hyperlinks_tokens = diff.map { |token| token[-1].eql?('.') ? token[0...-1] : token }.map { |token| token[-1].eql?(')') ? token[0...-1] : token }.map { |token| token[0].eql?('(') ? token[1..token.length] : token }
      end
      [redacted_text.gsub(/(?<=[^\>]|\A)#{Regexp.escape(hyperlink_text)}/, "<span class='confidentialHyperlinks'>#{hyperlink_text}</span>"), final_hyperlinks_tokens]
    end

    def redact_numbers_html(txt)
      redacted_text = redact_numbers(txt).gsub(/\>\s#{Regexp.escape(token_text)}\s\</, ">#{token_text}<").gsub(/\>\s#{Regexp.escape(number_text)}\s\</, ">#{number_text}<").gsub(/\>\s#{Regexp.escape(date_text)}\s\</, ">#{date_text}<").gsub(/\>\s#{Regexp.escape(email_text)}\s\</, ">#{email_text}<").gsub(/\>\s#{Regexp.escape(hyperlink_text)}\s\</, ">#{hyperlink_text}<")
      if language.eql?('ja')
        final_number_tokens = txt.scan(/[０１２３４５６７８９]+|\d+/)
      else
        original_sentence_array = txt.split(' ')
        redacted_sentence_array = redacted_text.split(' ')
        diff = original_sentence_array - redacted_sentence_array
        if original_sentence_array.length.eql?(1)
          final_number_tokens = diff
        else
          final_number_tokens = diff.map { |token| token[-1].eql?('.') ? token[0...-1] : token }
                                    .map { |token| token[-1].eql?(')') ? token[0...-1] : token }
                                    .map { |token| token[-1].eql?("'") ? token[0...-1] : token }
                                    .map { |token| token[-1].eql?('’') ? token[0...-1] : token }
                                    .map { |token| token[0].eql?('(') ? token[1..token.length] : token }
                                    .map { |token| token[0].eql?("'") ? token[1..token.length] : token }
                                    .map { |token| token[0].eql?("‘") ? token[1..token.length] : token }
        end
      end
      [redacted_text.gsub(/(?<=[^\>]|\A)#{Regexp.escape(number_text)}/, "<span class='confidentialNumber'>#{number_text}</span>"), final_number_tokens]
    end

    def redact_emails_html(txt)
      redacted_text = redact_emails(txt).gsub(/\>\s#{Regexp.escape(token_text)}\s\</, ">#{token_text}<").gsub(/\>\s#{Regexp.escape(number_text)}\s\</, ">#{number_text}<").gsub(/\>\s#{Regexp.escape(date_text)}\s\</, ">#{date_text}<").gsub(/\>\s#{Regexp.escape(email_text)}\s\</, ">#{email_text}<").gsub(/\>\s#{Regexp.escape(hyperlink_text)}\s\</, ">#{hyperlink_text}<")
      if language.eql?('ja')
        final_email_tokens = txt.scan(/([\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+)/i).map { |token| token[0] }
      else
        original_sentence_array = txt.split(' ')
        redacted_sentence_array = redacted_text.split(' ')
        diff = original_sentence_array - redacted_sentence_array
        final_email_tokens = diff.map { |token| token[-1].eql?('.') ? token[0...-1] : token }.map { |token| token[-1].eql?(')') ? token[0...-1] : token }.map { |token| token[0].eql?('(') ? token[1..token.length] : token }
      end
      [redacted_text.gsub(/(?<=[^\>]|\A)#{Regexp.escape(email_text)}/, "<span class='confidentialEmail'>#{email_text}</span>"), final_email_tokens]
    end

    def redact_dates_html(txt)
      redacted_text = redact_dates(txt)
      if language.eql?('ja')
        final_date_tokens = txt.scan(/[０１２３４５６７８９]+年[０１２３４５６７８９]+月[０１２３４５６７８９]+日|[０１２３４５６７８９]+月[０１２３４５６７８９]+日/)
      else
        original_sentence_array = txt.split(' ')
        redacted_sentence_array = redacted_text.split(' ')
        diff = original_sentence_array - redacted_sentence_array
        date_tokens = []
        redacted_text.split(' ').each_with_index do |redacted_token, index|
          if redacted_token.gsub(/\./, '') == date_text
            original_sentence_array.each_with_index do |original_token, i|
              date_tokens << original_token if original_sentence_array.length == 1
              if redacted_sentence_array[index - 1] == original_token &&
                diff.include?(original_sentence_array[i + 1]) &&
                original_sentence_array[i + 2] == redacted_sentence_array[index + 1]
                date_tokens << original_sentence_array[i + 1]
              end
              if redacted_sentence_array[index - 1] == original_token &&
                diff.include?(original_sentence_array[i + 1]) &&
                diff.include?(original_sentence_array[i + 2]) &&
                original_sentence_array[i + 3] == redacted_sentence_array[index + 1]
                date_tokens << original_sentence_array[i + 1] + ' ' + original_sentence_array[i + 2]
              end
              if redacted_sentence_array[index - 1] == original_token &&
                diff.include?(original_sentence_array[i + 1]) &&
                diff.include?(original_sentence_array[i + 2]) &&
                diff.include?(original_sentence_array[i + 3]) &&
                original_sentence_array[i + 4] == redacted_sentence_array[index + 1]
                date_tokens << original_sentence_array[i + 1] + ' ' + original_sentence_array[i + 2] + ' ' + original_sentence_array[i + 3]
              end
              if redacted_sentence_array[index - 1] == original_token &&
                diff.include?(original_sentence_array[i + 1]) &&
                diff.include?(original_sentence_array[i + 2]) &&
                diff.include?(original_sentence_array[i + 3]) &&
                diff.include?(original_sentence_array[i + 4]) &&
                original_sentence_array[i + 5] == redacted_sentence_array[index + 1]
                date_tokens << original_sentence_array[i + 1] + ' ' + original_sentence_array[i + 2] + ' ' + original_sentence_array[i + 3] + ' ' + original_sentence_array[i + 4]
              end
            end
          end
        end
        final_date_tokens = date_tokens.map { |token| token[-1].eql?('.') ? token[0...-1] : token }
      end
      [redacted_text.gsub(/#{Regexp.escape(date_text)}/, "<span class='confidentialDate'>#{date_text}</span>"), final_date_tokens]
    end

    def redact_hyperlinks(txt)
      ConfidentialInfoRedactorLite::Hyperlink.new.replace(txt).gsub(/<redacted hyperlink>/, "#{hyperlink_text}").gsub(/\s*#{Regexp.escape(hyperlink_text)}\s*/, " #{hyperlink_text} ").gsub(/#{Regexp.escape(hyperlink_text)}\s{1}\.{1}/, "#{hyperlink_text}.").gsub(/#{Regexp.escape(hyperlink_text)}\s{1}\,{1}/, "#{hyperlink_text},")
    end

    def redact_dates(txt)
      ConfidentialInfoRedactorLite::Date.new(dow: dow, dow_abbr: dow_abbr, months: months, months_abbr: months_abbr).replace(txt).gsub(/<redacted date>/, "#{date_text}").gsub(/\s*#{Regexp.escape(date_text)}\s*/, " #{date_text} ").gsub(/\A\s*#{Regexp.escape(date_text)}\s*/, "#{date_text} ").gsub(/#{Regexp.escape(date_text)}\s{1}\.{1}/, "#{date_text}.").strip
    end

    def redact_numbers(txt)
      txt.gsub(NUMBER_REGEX, " #{number_text} ").gsub(/[０１２３４５６７８９]+/, " #{number_text} ").gsub(/\s*#{Regexp.escape(number_text)}\s*/, " #{number_text} ").gsub(/\A\s*#{Regexp.escape(number_text)}\s*/, "#{number_text} ").gsub(/#{Regexp.escape(number_text)}\s{1}\.{1}/, "#{number_text}.").gsub(/#{Regexp.escape(number_text)}\s{1}\,{1}/, "#{number_text},").gsub(/#{Regexp.escape(number_text)}\s{1}\){1}/, "#{number_text})").gsub(/\(\s{1}#{Regexp.escape(number_text)}/, "(#{number_text}").gsub(/#{Regexp.escape(number_text)}\s\z/, "#{number_text}")
    end

    def redact_emails(txt)
      txt.gsub(EMAIL_REGEX, "#{email_text}")
    end

    def redact_tokens(txt)
      tokens.sort_by{ |x| x.split.count }.reverse.each do |token|
        txt.gsub!(/(?<=\s|^|\")#{Regexp.escape(token)}(?=\W|$)/, "#{token_text}")
      end
      txt
    end
  end
end
