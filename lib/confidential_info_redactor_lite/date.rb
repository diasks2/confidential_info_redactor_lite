module ConfidentialInfoRedactorLite
  class Date
    # Rubular: http://rubular.com/r/73CZ2HU0q6
    DMY_MDY_REGEX = /(\d{1,2}(\/|\.|-)){2}\d{4}/

    # Rubular: http://rubular.com/r/GWbuWXw4t0
    YMD_YDM_REGEX = /\d{4}(\/|\.|-)(\d{1,2}(\/|\.|-)){2}/

    # Rubular: http://rubular.com/r/SRZ27XNlvR
    DIGIT_ONLY_YEAR_FIRST_REGEX = /[12]\d{7}\D/

    # Rubular: http://rubular.com/r/mpVSeaKwdY
    DIGIT_ONLY_YEAR_LAST_REGEX = /\d{4}[12]\d{3}\D/

    JA_DATE_REGEX_LONG = /[０１２３４５６７８９]+年[０１２３４５６７８９]+月[０１２３４５６７８９]+日/

    JA_DATE_REGEX_SHORT = /[０１２３４５６７８９]+月[０１２３４５６７８９]+日/

    attr_reader :dow, :dow_abbr, :months, :months_abbr
    def initialize(dow:, dow_abbr:, months:, months_abbr:)
      @dow = dow
      @dow_abbr = dow_abbr
      @months = months
      @months_abbr = months_abbr
    end

    def includes_date?(text)
      long_date(text) || number_only_date(text)
    end

    def replace(text)
      return text unless dow.kind_of?(Array) && dow_abbr.kind_of?(Array) && months.kind_of?(Array) && months_abbr.kind_of?(Array)
      new_string = text.dup
      counter = 0
      dow_abbr.each do |day|
        counter +=1 if text.include?('day')
      end
      new_string = new_string.gsub(JA_DATE_REGEX_LONG, '<redacted date>')
      new_string = new_string.gsub(JA_DATE_REGEX_SHORT, '<redacted date>')
      if counter > 0
        dow_abbr.each do |day|
          months.each do |month|
            new_string = new_string.gsub(/#{Regexp.escape(day)}(\.)*(,)*\s#{Regexp.escape(month)}\s\d+(rd|th|st)*(,)*\s\d{4}/i, ' <redacted date> ')
          end
          months_abbr.each do |month|
            new_string = new_string.gsub(/#{Regexp.escape(day)}(\.)*(,)*\s#{Regexp.escape(month)}(\.)*\s\d+(rd|th|st)*(,)*\s\d{4}/i, ' <redacted date> ')
          end
        end
        dow.each do |day|
          months.each do |month|
            new_string = new_string.gsub(/#{Regexp.escape(day)}(,)*\s#{Regexp.escape(month)}(\.)*\s\d+(rd|th|st)*(,)*\s\d{4}/i, ' <redacted date> ')
                                   .gsub(/\d+\s+de\s+#{Regexp.escape(month)}\s\d{4}/i, ' <redacted date> ')
                                   .gsub(/\d{2}(\.|-|\/)*\s?#{Regexp.escape(month)}(\.|-|\/)*\s?(\d{4}|\d{2})/i, ' <redacted date> ')
                                   .gsub(/#{Regexp.escape(month)}(\.)*\s\d+(rd|th|st)*(,)*\s\d{4}/i, ' <redacted date> ')
                                   .gsub(/\d{4}\.*\s#{Regexp.escape(month)}\s\d+(rd|th|st)*/i, ' <redacted date> ')
                                   .gsub(/\d{4}(\.|-|\/)*#{Regexp.escape(month)}(\.|-|\/)*\d+/i, ' <redacted date> ')
                                   .gsub(/#{Regexp.escape(month)}(\.)*\s\d+(rd|th|st)*/i, ' <redacted date> ')
                                   .gsub(/#{Regexp.escape(month)}\sde\s\d+(rd|th|st)*/i, ' <redacted date> ')
          end
          months_abbr.each do |month|
            new_string = new_string.gsub(/#{Regexp.escape(day)}(,)*\s#{Regexp.escape(month)}(\.)*\s\d+(rd|th|st)*(,)*\s\d{4}/i, ' <redacted date> ')
                                   .gsub(/\d+\s+de\s+#{Regexp.escape(month)}\s\d{4}/i, ' <redacted date> ')
                                   .gsub(/\d{2}(\.|-|\/)*\s?#{Regexp.escape(month)}(\.|-|\/)*\s?(\d{4}|\d{2})/i, ' <redacted date> ')
                                   .gsub(/#{Regexp.escape(month)}(\.)*\s\d+(rd|th|st)*(,)*\s\d{4}/i, ' <redacted date> ')
                                   .gsub(/\d{4}\.*\s#{Regexp.escape(month)}\s\d+(rd|th|st)*/i, ' <redacted date> ')
                                   .gsub(/\d{4}(\.|-|\/)*#{Regexp.escape(month)}(\.|-|\/)*\d+/i, ' <redacted date> ')
                                   .gsub(/#{Regexp.escape(month)}(\.)*\s\d+(rd|th|st)*/i, ' <redacted date> ')
                                   .gsub(/#{Regexp.escape(month)}\sde\s\d+(rd|th|st)*/i, ' <redacted date> ')
          end
        end
      else
        dow.each do |day|
          months.each do |month|
            new_string = new_string.gsub(/#{Regexp.escape(day)}(,)*\s#{Regexp.escape(month)}(\.)*\s\d+(rd|th|st)*(,)*\s\d{4}/i, ' <redacted date> ')
                                   .gsub(/\d+\s+de\s+#{Regexp.escape(month)}\s\d{4}/i, ' <redacted date> ')
                                   .gsub(/\d{2}(\.|-|\/)*\s?#{Regexp.escape(month)}(\.|-|\/)*\s?(\d{4}|\d{2})/i, ' <redacted date> ')
                                   .gsub(/#{Regexp.escape(month)}(\.)*\s\d+(rd|th|st)*(,)*\s\d{4}/i, ' <redacted date> ')
                                   .gsub(/\d{4}\.*\s#{Regexp.escape(month)}\s\d+(rd|th|st)*/i, ' <redacted date> ')
                                   .gsub(/\d{4}(\.|-|\/)*#{Regexp.escape(month)}(\.|-|\/)*\d+/i, ' <redacted date> ')
                                   .gsub(/#{Regexp.escape(month)}(\.)*\s\d+(rd|th|st)*/i, ' <redacted date> ')
                                   .gsub(/#{Regexp.escape(month)}\sde\s\d+(rd|th|st)*/i, ' <redacted date> ')
          end
          months_abbr.each do |month|
            new_string = new_string.gsub(/#{Regexp.escape(day)}(,)*\s#{Regexp.escape(month)}(\.)*\s\d+(rd|th|st)*(,)*\s\d{4}/i, ' <redacted date> ')
                                   .gsub(/\d+\s+de\s+#{Regexp.escape(month)}\s\d{4}/i, ' <redacted date> ')
                                   .gsub(/\d{2}(\.|-|\/)*\s?#{Regexp.escape(month)}(\.|-|\/)*\s?(\d{4}|\d{2})/i, ' <redacted date> ')
                                   .gsub(/#{Regexp.escape(month)}(\.)*\s\d+(rd|th|st)*(,)*\s\d{4}/i, ' <redacted date> ')
                                   .gsub(/\d{4}\.*\s#{Regexp.escape(month)}\s\d+(rd|th|st)*/i, ' <redacted date> ')
                                   .gsub(/\d{4}(\.|-|\/)*#{Regexp.escape(month)}(\.|-|\/)*\d+/i, ' <redacted date> ')
                                   .gsub(/#{Regexp.escape(month)}(\.)*\s\d+(rd|th|st)*/i, ' <redacted date> ')
                                   .gsub(/#{Regexp.escape(month)}\sde\s\d+(rd|th|st)*/i, ' <redacted date> ')
          end
        end
        dow_abbr.each do |day|
          months.each do |month|
            new_string = new_string.gsub(/#{Regexp.escape(day)}(\.)*(,)*\s#{Regexp.escape(month)}\s\d+(rd|th|st)*(,)*\s\d{4}/i, ' <redacted date> ')
          end
          months_abbr.each do |month|
            new_string = new_string.gsub(/#{Regexp.escape(day)}(\.)*(,)*\s#{Regexp.escape(month)}(\.)*\s\d+(rd|th|st)*(,)*\s\d{4}/i, ' <redacted date> ')
          end
        end
      end
      new_string = new_string.gsub(DMY_MDY_REGEX, ' <redacted date> ')
                     .gsub(YMD_YDM_REGEX, ' <redacted date> ')
                     .gsub(DIGIT_ONLY_YEAR_FIRST_REGEX, ' <redacted date> ')
                     .gsub(DIGIT_ONLY_YEAR_LAST_REGEX, ' <redacted date> ')
    end

    def occurences(text)
      replace(text).scan(/<redacted date>/).size
    end

    def replace_number_only_date(text)
      text.gsub(DMY_MDY_REGEX, ' <redacted date> ')
            .gsub(YMD_YDM_REGEX, ' <redacted date> ')
            .gsub(DIGIT_ONLY_YEAR_FIRST_REGEX, ' <redacted date> ')
            .gsub(DIGIT_ONLY_YEAR_LAST_REGEX, ' <redacted date> ')
    end

    private

    def long_date(text)
      match_found = false
      dow.each do |day|
        months.each do |month|
          break if match_found
          match_found = check_for_matches(day, month, text)
        end
        months_abbr.each do |month|
          break if match_found
          match_found = check_for_matches(day, month, text)
        end
      end
      dow_abbr.each do |day|
        months.each do |month|
          break if match_found
          match_found = !(text !~ /#{Regexp.escape(day)}(\.)*(,)*\s#{Regexp.escape(month)}\s\d+(rd|th|st)*(,)*\s\d{4}/i)
        end
        months_abbr.each do |month|
          break if match_found
          match_found = !(text !~ /#{Regexp.escape(day)}(\.)*(,)*\s#{Regexp.escape(month)}(\.)*\s\d+(rd|th|st)*(,)*\s\d{4}/i)
        end
      end
      match_found
    end

    def number_only_date(text)
      !(text !~ DMY_MDY_REGEX) ||
      !(text !~ YMD_YDM_REGEX) ||
      !(text !~ DIGIT_ONLY_YEAR_FIRST_REGEX) ||
      !(text !~ DIGIT_ONLY_YEAR_LAST_REGEX)
    end

    def check_for_matches(day, month, text)
      !(text !~ /#{Regexp.escape(day)}(,)*\s#{Regexp.escape(month)}(\.)*\s\d+(rd|th|st)*(,)*\s\d{4}/i) ||
      !(text !~ /#{Regexp.escape(month)}(\.)*\s\d+(rd|th|st)*(,)*\s\d{4}/i) ||
      !(text !~ /\d{4}\.*\s#{Regexp.escape(month)}\s\d+(rd|th|st)*/i) ||
      !(text !~ /\d{4}(\.|-|\/)*#{Regexp.escape(month)}(\.|-|\/)*\d+/i) ||
      !(text !~ /#{Regexp.escape(month)}(\.)*\s\d+(rd|th|st)*/i) ||
      !(text !~ /\d{2}(\.|-|\/)*#{Regexp.escape(month)}(\.|-|\/)*(\d{4}|\d{2})/i)
    end
  end
end
