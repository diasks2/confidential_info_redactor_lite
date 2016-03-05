require 'spec_helper'

RSpec.describe ConfidentialInfoRedactorLite::Date do
  let(:en_dow) { %w(monday tuesday wednesday thursday friday saturday sunday) }
  let(:en_dow_abbr) { %w(mon tu tue tues wed th thu thur thurs fri sat sun) }
  let(:en_months) { %w(january february march april may june july august september october november december) }
  let(:en_month_abbr) { %w(jan feb mar apr jun jul aug sep sept oct nov dec) }

  let(:de_dow) { %w(montag dienstag mittwoch donnerstag freitag samstag sonntag sonnabend) }
  let(:de_dow_abbr) { %w(mo di mi do fr sa so) }
  let(:de_months) { %w(januar februar märz april mai juni juli august september oktober november dezember) }
  let(:de_month_abbr) { %w(jan jän feb märz apr mai juni juli aug sep sept okt nov dez) }

  let(:ja_dow) { %w(月曜日 火曜日 水曜日 木曜日 金曜日 土曜日 日曜日) }
  let(:ja_dow_abbr) { %w(月 火 水 木 金 土 日) }
  let(:ja_months) { %w(１月 ２月 ３月 ４月 ５月 ６月 ７月 ８月 ９月 １０月 １１月 １２月 1月 2月 3月 4月 5月 6月 7月 8月 9月 10月 11月 12月) }
  let(:ja_month_abbr) { %w(１月 ２月 ３月 ４月 ５月 ６月 ７月 ８月 ９月 １０月 １１月 １２月 1月 2月 3月 4月 5月 6月 7月 8月 9月 10月 11月 12月) }

  context '#includes_date?' do
    it 'returns true if the text includes a date #001' do
      text = 'Today is Monday, April 4th, 2011, aka 04/04/2011.'
      ws = ConfidentialInfoRedactorLite::Date.new(dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr)
      expect(ws.includes_date?(text)).to eq(true)
    end

    it 'returns true if the text includes a date #002' do
      text = 'Today is Monday April 4th 2011.'
      ws = ConfidentialInfoRedactorLite::Date.new(dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr)
      expect(ws.includes_date?(text)).to eq(true)
    end

    it 'returns true if the text includes a date #003' do
      text = 'Today is April 4th, 2011.'
      ws = ConfidentialInfoRedactorLite::Date.new(dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr)
      expect(ws.includes_date?(text)).to eq(true)
    end

    it 'returns true if the text includes a date #004' do
      text = 'Today is Mon., Apr. 4, 2011.'
      ws = ConfidentialInfoRedactorLite::Date.new(dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr)
      expect(ws.includes_date?(text)).to eq(true)
    end

    it 'returns true if the text includes a date #005' do
      text = 'Today is 04/04/2011.'
      ws = ConfidentialInfoRedactorLite::Date.new(dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr)
      expect(ws.includes_date?(text)).to eq(true)
    end

    it 'returns true if the text includes a date #006' do
      text = 'Today is 04.04.2011.'
      ws = ConfidentialInfoRedactorLite::Date.new(dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr)
      expect(ws.includes_date?(text)).to eq(true)
    end

    it 'returns true if the text includes a date #007' do
      text = 'Today is 2011.04.04.'
      ws = ConfidentialInfoRedactorLite::Date.new(dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr)
      expect(ws.includes_date?(text)).to eq(true)
    end

    it 'returns true if the text includes a date #008' do
      text = 'Today is 2011/04/04.'
      ws = ConfidentialInfoRedactorLite::Date.new(dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr)
      expect(ws.includes_date?(text)).to eq(true)
    end

    it 'returns true if the text includes a date #009' do
      text = 'Today is 2011-04-04.'
      ws = ConfidentialInfoRedactorLite::Date.new(dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr)
      expect(ws.includes_date?(text)).to eq(true)
    end

    it 'returns true if the text includes a date #010' do
      text = 'Today is 04-04-2011.'
      ws = ConfidentialInfoRedactorLite::Date.new(dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr)
      expect(ws.includes_date?(text)).to eq(true)
    end

    it 'returns true if the text includes a date #011' do
      text = 'Today is 2003 November 9.'
      ws = ConfidentialInfoRedactorLite::Date.new(dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr)
      expect(ws.includes_date?(text)).to eq(true)
    end

    it 'returns true if the text includes a date #012' do
      text = 'Today is 2003Nov9.'
      ws = ConfidentialInfoRedactorLite::Date.new(dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr)
      expect(ws.includes_date?(text)).to eq(true)
    end

    it 'returns true if the text includes a date #013' do
      text = 'Today is 2003Nov09.'
      ws = ConfidentialInfoRedactorLite::Date.new(dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr)
      expect(ws.includes_date?(text)).to eq(true)
    end

    it 'returns true if the text includes a date #014' do
      text = 'Today is 2003-Nov-9.'
      ws = ConfidentialInfoRedactorLite::Date.new(dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr)
      expect(ws.includes_date?(text)).to eq(true)
    end

    it 'returns true if the text includes a date #015' do
      text = 'Today is 2003-Nov-09.'
      ws = ConfidentialInfoRedactorLite::Date.new(dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr)
      expect(ws.includes_date?(text)).to eq(true)
    end

    it 'returns true if the text includes a date #016' do
      text = 'Today is 2003-Nov-9, Sunday.'
      ws = ConfidentialInfoRedactorLite::Date.new(dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr)
      expect(ws.includes_date?(text)).to eq(true)
    end

    it 'returns true if the text includes a date #017' do
      text = 'Today is 2003. november 9.'
      ws = ConfidentialInfoRedactorLite::Date.new(dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr)
      expect(ws.includes_date?(text)).to eq(true)
    end

    it 'returns true if the text includes a date #018' do
      text = 'Today is 2003.11.9.'
      ws = ConfidentialInfoRedactorLite::Date.new(dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr)
      expect(ws.includes_date?(text)).to eq(true)
    end

    it 'returns true if the text includes a date #019' do
      text = 'Today is Monday, Apr. 4, 2011.'
      ws = ConfidentialInfoRedactorLite::Date.new(dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr)
      expect(ws.includes_date?(text)).to eq(true)
    end

    it 'returns true if the text includes a date #020' do
      text = 'Today is 2003/11/09.'
      ws = ConfidentialInfoRedactorLite::Date.new(dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr)
      expect(ws.includes_date?(text)).to eq(true)
    end

    it 'returns true if the text includes a date #021' do
      text = 'Today is 20030109.'
      ws = ConfidentialInfoRedactorLite::Date.new(dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr)
      expect(ws.includes_date?(text)).to eq(true)
    end

    it 'returns true if the text includes a date #022' do
      text = 'Today is 01092003.'
      ws = ConfidentialInfoRedactorLite::Date.new(dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr)
      expect(ws.includes_date?(text)).to eq(true)
    end

    it 'returns true if the text includes a date #023' do
      text = 'Today is Sunday, November 9, 2014.'
      ws = ConfidentialInfoRedactorLite::Date.new(dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr)
      expect(ws.includes_date?(text)).to eq(true)
    end

    it 'returns true if the text includes a date #024' do
      text = 'Today is November 9, 2014.'
      ws = ConfidentialInfoRedactorLite::Date.new(dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr)
      expect(ws.includes_date?(text)).to eq(true)
    end

    it 'returns true if the text includes a date #025' do
      text = 'Today is Nov. 9, 2014.'
      ws = ConfidentialInfoRedactorLite::Date.new(dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr)
      expect(ws.includes_date?(text)).to eq(true)
    end

    it 'returns true if the text includes a date #026' do
      text = 'Today is july 1st.'
      ws = ConfidentialInfoRedactorLite::Date.new(dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr)
      expect(ws.includes_date?(text)).to eq(true)
    end

    it 'returns true if the text includes a date #027' do
      text = 'Today is jul. 1st.'
      ws = ConfidentialInfoRedactorLite::Date.new(dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr)
      expect(ws.includes_date?(text)).to eq(true)
    end

    it 'returns true if the text includes a date #028' do
      text = 'Today is 8 November 2014.'
      ws = ConfidentialInfoRedactorLite::Date.new(dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr)
      expect(ws.includes_date?(text)).to eq(true)
    end

    it 'returns true if the text includes a date #029' do
      text = 'Today is 8. November 2014.'
      ws = ConfidentialInfoRedactorLite::Date.new(dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr)
      expect(ws.includes_date?(text)).to eq(true)
    end

    it 'returns true if the text includes a date #030' do
      text = 'Today is 08-Nov-2014.'
      ws = ConfidentialInfoRedactorLite::Date.new(dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr)
      expect(ws.includes_date?(text)).to eq(true)
    end

    it 'returns true if the text includes a date #031' do
      text = 'Today is 08Nov14.'
      ws = ConfidentialInfoRedactorLite::Date.new(dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr)
      expect(ws.includes_date?(text)).to eq(true)
    end

    it 'returns true if the text includes a date #032' do
      text = 'Today is 8th November 2014.'
      ws = ConfidentialInfoRedactorLite::Date.new(dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr)
      expect(ws.includes_date?(text)).to eq(true)
    end

    it 'returns true if the text includes a date #033' do
      text = 'Today is the 8th of November 2014.'
      ws = ConfidentialInfoRedactorLite::Date.new(dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr)
      expect(ws.includes_date?(text)).to eq(true)
    end

    it 'returns true if the text includes a date #034' do
      text = 'Today is 08/Nov/2014.'
      ws = ConfidentialInfoRedactorLite::Date.new(dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr)
      expect(ws.includes_date?(text)).to eq(true)
    end

    it 'returns true if the text includes a date #035' do
      text = 'Today is Sunday, 8 November 2014.'
      ws = ConfidentialInfoRedactorLite::Date.new(dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr)
      expect(ws.includes_date?(text)).to eq(true)
    end

    it 'returns true if the text includes a date #036' do
      text = 'Today is 8 November 2014.'
      ws = ConfidentialInfoRedactorLite::Date.new(dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr)
      expect(ws.includes_date?(text)).to eq(true)
    end

    it 'returns false if the text does not include a date #037' do
      text = 'Hello world. There is no date here - $50,000. The sun is hot.'
      ws = ConfidentialInfoRedactorLite::Date.new(dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr)
      expect(ws.includes_date?(text)).to eq(false)
    end

    it 'returns false if the text does not include a date #037' do
      text = '88966-5.0-ENG'
      ws = ConfidentialInfoRedactorLite::Date.new(dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr)
      expect(ws.includes_date?(text)).to eq(false)
    end
  end

  context '#occurences' do
    it 'counts the date occurences in a text #001' do
      text = 'Today is Sunday, 8 November 2014.'
      ws = ConfidentialInfoRedactorLite::Date.new(dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr)
      expect(ws.occurences(text)).to eq(1)
    end

    it 'counts the date occurences in a text #002' do
      text = 'Today is Sunday, 8 November 2014. Yesterday was 07/Nov/2014.'
      ws = ConfidentialInfoRedactorLite::Date.new(dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr)
      expect(ws.occurences(text)).to eq(2)
    end
  end

  context '#replace' do
    context 'English (en)' do
      it 'replaces the date occurences in a text #001' do
        text = 'Today is Tues. March 3rd, 2011.'
        ws = ConfidentialInfoRedactorLite::Date.new(dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr)
        expect(ws.replace(text)).to eq('Today is  <redacted date> .')
      end

      it 'replaces the date occurences in a text #002' do
        text = 'The scavenger hunt ends on Dec. 31st, 2011.'
        ws = ConfidentialInfoRedactorLite::Date.new(dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr)
        expect(ws.replace(text)).to eq('The scavenger hunt ends on  <redacted date> .')
      end
    end

    context 'German (de)' do
      it 'replaces the date occurences in a text #001' do
        text = '15. Oktober 2015'
        ws = ConfidentialInfoRedactorLite::Date.new(dow: de_dow, dow_abbr: de_dow_abbr, months: de_months, months_abbr: de_month_abbr)
        expect(ws.replace(text)).to eq(' <redacted date> ')
      end

      it 'replaces the date occurences in a text #002' do
        text = 'Oktober de 15'
        ws = ConfidentialInfoRedactorLite::Date.new(dow: de_dow, dow_abbr: de_dow_abbr, months: de_months, months_abbr: de_month_abbr)
        expect(ws.replace(text)).to eq(' <redacted date> ')
      end

      it 'replaces the date occurences in a text #003' do
        text = '15 de Oktober 2020'
        ws = ConfidentialInfoRedactorLite::Date.new(dow: de_dow, dow_abbr: de_dow_abbr, months: de_months, months_abbr: de_month_abbr)
        expect(ws.replace(text)).to eq(' <redacted date> ')
      end
    end

    context 'Japanese (ja)' do
      it 'replaces the date occurences in a text #001' do
        text = '２０１１年１２月３１日です。'
        ws = ConfidentialInfoRedactorLite::Date.new(dow: ja_dow, dow_abbr: ja_dow_abbr, months: ja_months, months_abbr: ja_month_abbr)
        expect(ws.replace(text)).to eq('<redacted date>です。')
      end
    end
  end

  context '#replace_number_only_date' do
    it 'replaces only the number date occurences in a text' do
      text = 'Today is Tues. March 3rd, 2011. 4/28/2013'
      ws = ConfidentialInfoRedactorLite::Date.new(dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr)
      expect(ws.replace_number_only_date(text)).to eq("Today is Tues. March 3rd, 2011.  <redacted date> ")
    end
  end
end
