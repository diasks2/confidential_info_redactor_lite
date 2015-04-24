require 'spec_helper'

RSpec.describe ConfidentialInfoRedactorLite::Redactor do
  let(:corpus) { ['i', 'in', 'you', 'top', 'so', 'are', 'december', 'please'] }
  let(:en_dow) { %w(monday tuesday wednesday thursday friday saturday sunday) }
  let(:en_dow_abbr) { %w(mon tu tue tues wed th thu thur thurs fri sat sun) }
  let(:en_months) { %w(january february march april may june july august september october november december) }
  let(:en_month_abbr) { %w(jan feb mar apr jun jul aug sep sept oct nov dec) }

  describe '#dates' do
    it 'redacts dates from a text #001' do
      text = 'Coca-Cola announced a merger with Pepsi that will happen on December 15th, 2020 for $200,000,000,000.'
      expect(described_class.new(text: text, language: 'en', dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr).dates).to eq('Coca-Cola announced a merger with Pepsi that will happen on <redacted date> for $200,000,000,000.')
    end

    it 'redacts dates from a text #002' do
      text = 'Coca-Cola announced a merger with Pepsi that will happen on December 15th, 2020.'
      expect(described_class.new(text: text, language: 'en', dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr).dates).to eq('Coca-Cola announced a merger with Pepsi that will happen on <redacted date>.')
    end

    it 'redacts dates from a text #003' do
      text = 'December 5, 2010 - Coca-Cola announced a merger with Pepsi.'
      expect(described_class.new(text: text, language: 'en', dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr).dates).to eq('<redacted date> - Coca-Cola announced a merger with Pepsi.')
    end

    it 'redacts dates from a text #004' do
      text = 'The scavenger hunt ends on Dec. 31st, 2011.'
      expect(described_class.new(text: text, language: 'en', dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr).dates).to eq('The scavenger hunt ends on <redacted date>.')
    end

    it 'handles nil date objects' do
      text = 'The scavenger hunt ends on Dec. 31st, 2011.'
      expect(described_class.new(text: text, language: 'en', dow: nil, dow_abbr: nil, months: nil, months_abbr: nil).dates).to eq('The scavenger hunt ends on Dec. 31st, 2011.')
    end

    it 'handles empty string date objects' do
      text = 'The scavenger hunt ends on Dec. 31st, 2011.'
      expect(described_class.new(text: text, language: 'en', dow: '', dow_abbr: '', months: '', months_abbr: '').dates).to eq('The scavenger hunt ends on Dec. 31st, 2011.')
    end

    it 'handles empty array date objects' do
      text = 'The scavenger hunt ends on Dec. 31st, 2011.'
      expect(described_class.new(text: text, language: 'en', dow: [], dow_abbr: [], months: [], months_abbr: []).dates).to eq('The scavenger hunt ends on Dec. 31st, 2011.')
    end
  end

  describe '#dates_html' do
    it 'surrounds the redacted dates in spans and return the redacted dates from a text #001' do
      text = 'On May 1st, 2000 Coca-Cola announced a merger with Pepsi that will happen on December 15th, 2020.'
      expect(described_class.new(text: text, language: 'en', dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr, date_text: "*****").dates_html).to eq(["On <span class='confidentialDate'>*****</span> Coca-Cola announced a merger with Pepsi that will happen on <span class='confidentialDate'>*****</span>.", ['May 1st, 2000', 'December 15th, 2020']])
    end
  end

  describe '#numbers' do
    it 'redacts numbers from a text #001' do
      text = 'Coca-Cola announced a merger with Pepsi that will happen on <redacted date> for $200,000,000,000.'
      expect(described_class.new(text: text, language: 'en', dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr).numbers).to eq('Coca-Cola announced a merger with Pepsi that will happen on <redacted date> for <redacted number>.')
    end

    it 'redacts numbers from a text #002' do
      text = '200 years ago.'
      expect(described_class.new(text: text, language: 'en', dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr).numbers).to eq('<redacted number> years ago.')
    end

    it 'redacts numbers from a text #003' do
      text = 'It was his 1st time, not yet his 10th, not even his 2nd. The wood was 3/4" thick.'
      expect(described_class.new(text: text, language: 'en', dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr).numbers).to eq('It was his <redacted number> time, not yet his <redacted number>, not even his <redacted number>. The wood was <redacted number> thick.')
    end

    it 'redacts numbers from a text #004' do
      text = 'Checking file of %2'
      expect(described_class.new(text: text, language: 'en', dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr).numbers).to eq('Checking file of <redacted number>')
    end

    it 'redacts numbers from a text #005' do
      text = 'zawiera pliki skompresowane (%2).'
      expect(described_class.new(text: text, language: 'en', dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr).numbers).to eq('zawiera pliki skompresowane (<redacted number>).')
    end
  end

  describe '#numbers_html' do
    it 'surrounds the redacted numbers in spans and return the redacted numbers from a text #001' do
      text = 'It was his 1st) time, not yet his 10th, not even his 2nd. The wood was 3/4" thick. It cost $200,000.'
      expect(described_class.new(text: text, language: 'en', dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr, number_text: "*****").numbers_html).to eq(["It was his <span class='confidentialNumber'>*****</span>) time, not yet his <span class='confidentialNumber'>*****</span>, not even his <span class='confidentialNumber'>*****</span>. The wood was <span class='confidentialNumber'>*****</span> thick. It cost <span class='confidentialNumber'>*****</span>.", ["1st", "10th,", "2nd", "3/4\"", "$200,000"]])
    end
  end

  describe '#emails' do
    it 'redacts email addresses from a text #001' do
      text = 'His email is john@gmail.com or you can try k.light@tuv.eu.us.'
      expect(described_class.new(text: text, language: 'en', dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr).emails).to eq('His email is <redacted email> or you can try <redacted email>.')
    end

    it 'redacts email addresses from a text #002' do
      text = 'His email is (john@gmail.com) or you can try (k.light@tuv.eu.us).'
      expect(described_class.new(text: text, language: 'en', dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr).emails).to eq('His email is (<redacted email>) or you can try (<redacted email>).')
    end
  end

  describe '#emails_html' do
    it 'surrounds the redacted emails in spans and return the redacted emails from a text #001' do
      text = 'His email is (john@gmail.com) or you can try (k.light@tuv.eu.us).'
      expect(described_class.new(text: text, language: 'en', dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr, token_text: "*****").emails_html).to eq(["His email is (<span class='confidentialEmail'><redacted email></span>) or you can try (<span class='confidentialEmail'><redacted email></span>).", ["john@gmail.com", "k.light@tuv.eu.us"]])
    end
  end

  describe '#hyperlinks' do
    it 'redacts hyperlinks from a text #001' do
      text = 'Visit https://www.tm-town.com for more info.'
      expect(described_class.new(text: text, language: 'en', dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr).hyperlinks).to eq('Visit <redacted hyperlink> for more info.')
    end
  end

  describe '#hyperlinks_html' do
    it 'surrounds the redacted hyperlinks in spans and return the redacted hyperlinks from a text #001' do
      text = 'Visit https://www.tm-town.com for more info or https://www.google.com.'
      expect(described_class.new(text: text, language: 'en', dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr, token_text: "*****", hyperlink_text: "*****", email_text: "*****").hyperlinks_html).to eq(["Visit <span class='confidentialHyperlinks'>*****</span> for more info or <span class='confidentialHyperlinks'>*****</span>.", ["https://www.tm-town.com", "https://www.google.com"]])
    end
  end

  describe '#proper_nouns' do
    it 'redacts tokens from a text #001' do
      tokens = ['Coca-Cola', 'Pepsi']
      text = 'Coca-Cola announced a merger with Pepsi that will happen on on December 15th, 2020 for $200,000,000,000.'
      expect(described_class.new(text: text, language: 'en', tokens: tokens, dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr).proper_nouns).to eq('<redacted> announced a merger with <redacted> that will happen on on December 15th, 2020 for $200,000,000,000.')
    end

    it 'redacts tokens from a text #002' do
      tokens = ['Coca-Cola', 'Pepsi']
      text = 'Coca-Cola announced a merger with Pepsi that will happen on on December 15th, 2020 for $200,000,000,000.'
      expect(described_class.new(text: text, language: 'en', tokens: tokens, token_text: '*****', dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr).proper_nouns).to eq('***** announced a merger with ***** that will happen on on December 15th, 2020 for $200,000,000,000.')
    end
  end

  describe '#redact' do
    it 'redacts all confidential information from a text #001' do
      tokens = ['Coca-Cola', 'Pepsi']
      text = 'Coca-Cola announced a merger with Pepsi that will happen on on December 15th, 2020 for $200,000,000,000.'
      expect(described_class.new(text: text, language: 'en', tokens: tokens, dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr).redact).to eq('<redacted> announced a merger with <redacted> that will happen on on <redacted date> for <redacted number>.')
    end

    it 'redacts all confidential information from a text #002' do
      text = <<-EOF
        Putter King Miniature Golf Scavenger Hunt

        Putter King is hosting the 1st Annual Miniature Golf Scavenger Hunt.  So get out your putter and your camera and see if you have what it takes.  Are you a King?

        The Official List:

        #1) Autographs of 2 professional miniature golfers, each from a different country. (45 points; 5 bonus points if the professional miniature golfers are also from 2 different continents)

        #2) Picture of yourself next to each obstacle in our list of the Top 10 Nostalgic Miniature Golf Obstacles. (120 points; 20 bonus points for each obstacle that exactly matches the one pictured in the article)

        #3) Build your own full-size miniature golf hole. (75 points; up to 100 bonus points available depending on the craftsmanship, playability, creativity and fun factor of your hole)

        #4) Video of yourself making a hole-in-one on two consecutive miniature golf holes. The video must be one continuous shot with no editing. (60 points)

        #5) Picture of yourself with the Putter King mascot. (50 points; 15 bonus points if you are wearing a Putter King t-shirt)

        #6) Picture of yourself with the completed Putter King wobblehead. (15 points; 15 bonus points if the picture is taken at a miniature golf course)

        #7) Picture of a completed scorecard from a round of miniature golf. The round of golf must have taken place after the start of this scavenger hunt. (10 points)

        #8) Picture of completed scorecards from 5 different miniature golf courses. Each round of golf must have taken place after the start of this scavenger hunt. (35 points)

        #9) Submit an entry to the 2011 Putter King Hole Design Contest. (60 points; 40 bonus points if your entry gets more than 100 votes)

        #10) Screenshot from the Putter King app showing a 9-hole score below par. (10 points)

        #11) Screenshot from the Putter King app showing that you have successfully unlocked all of the holes in the game. (45 points)

        #12) Picture of the Putter King wobblehead at a World Heritage Site. (55 points)

        #13) Complete and submit the Putter King ‘Practice Activity’ and ‘Final Project’ for any one of the Putter King math or physics lessons. (40 points; 20 bonus points if you complete two lessons)

        #14) Picture of yourself with at least 6 different colored miniature golf balls. (10 points; 2 bonus points for each additional color {limit of 10 bonus points})

        #15) Picture of yourself with a famous golfer or miniature golfer. (15 points; 150 bonus points if the golfer is on the PGA tour AND you are wearing a Putter King t-shirt in the picture)

        #16) Video of yourself making a hole-in-one on a miniature golf hole with a loop-de-loop obstacle. (30 points)

        #17) Video of yourself successfully making a trick miniature golf shot. (40 points; up to 100 bonus points available depending on the difficulty and complexity of the trick shot)


        Prizes:

        $100 iTunes Gift Card

        Putter King Scavenger Hunt Trophy
        (6 3/4" Engraved Crystal Trophy - Picture Coming Soon)

        The Putter King team will judge the scavenger hunt and all decisions will be final. The U.S. Government is sponsoring it. The scavenger hunt is open to anyone and everyone.  The scavenger hunt ends on Dec. 31st, 2011.

        To enter the scavenger hunt, send an email to info AT putterking DOT com with the subject line: "Putter King Scavenger Hunt Submission".  In the email please include links to the pictures and videos you are submitting.  You can utilize free photo and video hosting sites such as YouTube, Flickr, Picasa, Photobucket, etc. for your submissions.

        By entering the Putter King Miniature Golf Scavenger Hunt, you allow Putter King to use or link to any of the pictures or videos you submit for advertisements and promotions.

        Don’t forget to use your imagination and creativity!
      EOF
      tokens = ConfidentialInfoRedactorLite::Extractor.new(text: text, corpus: corpus).extract
      expect(described_class.new(text: text, language: 'en', tokens: tokens, dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr).redact).to eq("        <redacted>\n\n        <redacted> is hosting the <redacted number> <redacted>.  So get out your putter and your camera and see if you have what it takes.  Are you a <redacted>?\n\n        <redacted>: <redacted number>) <redacted> of <redacted number> professional miniature golfers, each from a different country. (<redacted number> points; <redacted number> bonus points if the professional miniature golfers are also from <redacted number> different continents) <redacted number>) <redacted> of yourself next to each obstacle in our list of the Top <redacted number> <redacted>. (<redacted number> points; <redacted number> bonus points for each obstacle that exactly matches the one pictured in the article) <redacted number>) <redacted> your own full-size miniature golf hole. (<redacted number> points; up to <redacted number> bonus points available depending on the craftsmanship, playability, creativity and fun factor of your hole) <redacted number>) <redacted> of yourself making a hole-in-one on two consecutive miniature golf holes. <redacted> video must be one continuous shot with no editing. (<redacted number> points) <redacted number>) <redacted> of yourself with the <redacted> mascot. (<redacted number> points; <redacted number> bonus points if you are wearing a <redacted> t-shirt) <redacted number>) <redacted> of yourself with the completed <redacted> wobblehead. (<redacted number> points; <redacted number> bonus points if the picture is taken at a miniature golf course) <redacted number>) <redacted> of a completed scorecard from a round of miniature golf. <redacted> round of golf must have taken place after the start of this scavenger hunt. (<redacted number> points) <redacted number>) <redacted> of completed scorecards from <redacted number> different miniature golf courses. <redacted> round of golf must have taken place after the start of this scavenger hunt. (<redacted number> points) <redacted number>) <redacted> an entry to the <redacted number> <redacted>. (<redacted number> points; <redacted number> bonus points if your entry gets more than <redacted number> votes) <redacted number>) <redacted> from the <redacted> app showing a 9-hole score below par. (<redacted number> points) <redacted number>) <redacted> from the <redacted> app showing that you have successfully unlocked all of the holes in the game. (<redacted number> points) <redacted number>) <redacted> of the <redacted> wobblehead at a <redacted>. (<redacted number> points) <redacted number>) <redacted> and submit the <redacted> ‘Practice <redacted>’ and ‘Final <redacted>’ for any one of the <redacted> math or physics lessons. (<redacted number> points; <redacted number> bonus points if you complete two lessons) <redacted number>) <redacted> of yourself with at least <redacted number> different colored miniature golf balls. (<redacted number> points; <redacted number> bonus points for each additional color {limit of <redacted number> bonus points}) <redacted number>) <redacted> of yourself with a famous golfer or miniature golfer. (<redacted number> points; <redacted number> bonus points if the golfer is on the <redacted> tour <redacted> you are wearing a <redacted> t-shirt in the picture) <redacted number>) <redacted> of yourself making a hole-in-one on a miniature golf hole with a loop-de-loop obstacle. (<redacted number> points) <redacted number>) <redacted> of yourself successfully making a trick miniature golf shot. (<redacted number> points; up to <redacted number> bonus points available depending on the difficulty and complexity of the trick shot)\n\n\n        Prizes: <redacted number> <redacted> <redacted>\n\n        <redacted>\n        (<redacted number>  <redacted number> <redacted> - <redacted>)\n\n        <redacted> team will judge the scavenger hunt and all decisions will be final. <redacted> is sponsoring it. <redacted> scavenger hunt is open to anyone and everyone.  <redacted> scavenger hunt ends on <redacted date>.\n\n        <redacted> enter the scavenger hunt, send an email to info <redacted> putterking <redacted> com with the subject line: \"<redacted>\".  In the email please include links to the pictures and videos you are submitting.  You can utilize free photo and video hosting sites such as <redacted>, <redacted>, <redacted>, <redacted>, etc. for your submissions.\n\n        <redacted> entering the <redacted>, you allow <redacted> to use or link to any of the pictures or videos you submit for advertisements and promotions.\n\n        Don’t forget to use your imagination and creativity!\n")
    end

    it 'redacts all confidential information from a text #003' do
      tokens = ['Coca-Cola', 'Pepsi', 'John Smith']
      text = 'Coca-Cola announced a merger with Pepsi that will happen on December 15th, 2020 for $200,000,000,000. Please contact John Smith at j.smith@example.com or visit http://www.super-fake-merger.com.'
      expect(described_class.new(text: text, language: 'en', tokens: tokens, dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr).redact).to eq('<redacted> announced a merger with <redacted> that will happen on <redacted date> for <redacted number>. Please contact <redacted> at <redacted email> or visit <redacted hyperlink>.')
    end

    it 'redacts all confidential information from a text #004' do
      tokens = ['Coca-Cola', 'Pepsi', 'John Smith']
      text = 'Coca-Cola announced a merger with Pepsi that will happen on December 15th, 2020 for $200,000,000,000. Please contact John Smith at j.smith@example.com or visit http://www.super-fake-merger.com.'
      expect(described_class.new(text: text, language: 'en', tokens: tokens, ignore_numbers: true, dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr).redact).to eq('<redacted> announced a merger with <redacted> that will happen on <redacted date> for $200,000,000,000. Please contact <redacted> at <redacted email> or visit <redacted hyperlink>.')
    end

    it 'redacts all confidential information from a text #005' do
      tokens = ['Coca-Cola', 'Pepsi', 'John Smith']
      text = 'Coca-Cola announced a merger with Pepsi that will happen on December 15th, 2020 for $200,000,000,000. Please contact John Smith at j.smith@example.com or visit http://www.super-fake-merger.com.'
      expect(described_class.new(text: text, language: 'en', tokens: tokens, number_text: '**redacted number**', date_text: '^^redacted date^^', token_text: '*****', hyperlink_text: '*****', email_text: '*****', dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr).redact).to eq('***** announced a merger with ***** that will happen on ^^redacted date^^ for **redacted number**. Please contact ***** at ***** or visit *****.')
    end

    it 'redacts all confidential information from a text #006' do
      tokens = ['Trans']
      text = 'My Transformation - avoid Trans.'
      expect(described_class.new(text: text, language: 'en', tokens: tokens, number_text: '**redacted number**', date_text: '^^redacted date^^', token_text: '*****', hyperlink_text: '*****', email_text: '*****', dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr).redact).to eq('My Transformation - avoid *****.')
    end
  end

  describe '#redact_html' do
    it 'redacts all confidential information from a text #001' do
      tokens = ['Coca-Cola', 'Pepsi']
      text = 'Coca-Cola announced a merger with Pepsi that will happen on on December 15th, 2020 for $200,000,000,000. Find out more at https://www.merger.com or contact john@merger.com.'
      expect(described_class.new(text: text, language: 'en', tokens: tokens, dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr, number_text: '*****', hyperlink_text: '*****', email_text: '*****', date_text: '*****', token_text: '*****').redact_html).to eq("Coca-Cola announced a merger with Pepsi that will happen on on <span class='confidentialDate'>*****</span> for <span class='confidentialNumber'>*****</span>. Find out more at <span class='confidentialHyperlinks'>*****</span> or contact <span class='confidentialEmail'>*****</span>.")
    end

    it 'redacts all confidential information from a text #002' do
      tokens = ['Coca-Cola', 'Pepsi']
      text = 'Coca-Cola announced a merger with Pepsi that will happen on on December 15th, 2020 for $200,000,000,000. Find out more at https://www.merger.com or contact john@merger.com.'
      expect(described_class.new(text: text, language: 'en', tokens: tokens, dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr, email_text: '**email**', number_text: '**number**', date_text: '**date**', hyperlink_text: '**url**', token_text: '*****').redact).to eq("***** announced a merger with ***** that will happen on on **date** for **number**. Find out more at **url** or contact **email**.")
    end

    it 'redacts all confidential information from a text #003' do
      tokens = ['CLA']
      text = 'LEGAL DISCLAIMER - CLA will not be held reponsible for changes.'
      expect(described_class.new(text: text, language: 'en', tokens: tokens, dow: en_dow, dow_abbr: en_dow_abbr, months: en_months, months_abbr: en_month_abbr, email_text: '**email**', number_text: '**number**', date_text: '**date**', hyperlink_text: '**url**', token_text: '*****').redact).to eq("LEGAL DISCLAIMER - ***** will not be held reponsible for changes.")
    end
  end
end