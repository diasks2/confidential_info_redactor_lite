module ConfidentialInfoRedactorLite
  # This class extracts proper nouns from a text
  class Extractor
    # Rubular: http://rubular.com/r/qE0g4r9zR7
    EXTRACT_REGEX = /(?<=\s|^|\s\"|\s\“|\s\«|\s\‹|\s\”|\s\»|\s\›)([A-Z]\S*\s)*[A-Z]\S*(?=(\s|\.|\z))|(?<=\s|^|\s\"|\s\”|\s\»|\s\›|\s\“|\s\«|\s\‹)[i][A-Z][a-z]+/

    PUNCTUATION_REGEX = /[\?\)\(\!\\\/\"\:\;\,\”\“\«\»\‹\›]/
    attr_reader :text, :language, :corpus
    def initialize(text:, corpus:, **args)
      @text = text.gsub(/[’‘]/, "'")
      @corpus = corpus
      @language = args[:language] || 'en'
    end

    def extract
      extracted_terms = []
      PragmaticSegmenter::Segmenter.new(text: text, language: language).segment.each do |segment|
        initial_extracted_terms = segment.gsub(EXTRACT_REGEX).map { |match| match unless corpus.include?(match.downcase.gsub(PUNCTUATION_REGEX, '').gsub(/\'$/, '')) }.compact
        in_corpus = true
        initial_extracted_terms.each do |ngram|
          ngram.split(PUNCTUATION_REGEX).each do |t|
            unless corpus.include?(t.downcase.gsub(PUNCTUATION_REGEX, '').gsub(/\'$/, '').gsub(/\.\z/, '').strip)
              in_corpus = false
            end
          end
        end
        next if initial_extracted_terms.length.eql?(segment.split(' ').length) && in_corpus
        initial_extracted_terms.each do |ngram|
          ngram.split(PUNCTUATION_REGEX).each do |t|
            next if !(t !~ /.*\d+.*/)
            if corpus.include?(t.downcase.gsub(PUNCTUATION_REGEX, '').gsub(/\'$/, '').gsub(/\.\z/, '').strip.split(' ')[0]) && t.downcase.gsub(PUNCTUATION_REGEX, '').gsub(/\'$/, '').gsub(/\.\z/, '').strip.split(' ')[0] != 'the' && t.downcase.gsub(PUNCTUATION_REGEX, '').gsub(/\'$/, '').gsub(/\.\z/, '').strip.split(' ')[0] != 'deutsche' && t.downcase.gsub(PUNCTUATION_REGEX, '').gsub(/\'$/, '').gsub(/\.\z/, '').strip.split(' ').length.eql?(2)
              extracted_terms << t.gsub(PUNCTUATION_REGEX, '').gsub(/\'$/, '').gsub(/\.\z/, '').strip.split(' ')[1] unless corpus.include?(t.downcase.gsub(PUNCTUATION_REGEX, '').gsub(/\'$/, '').strip.split(' ')[1])
            else
              tracker = true
              unless t.gsub(PUNCTUATION_REGEX, '').gsub(/\'$/, '').gsub(/\.\z/, '').strip.split(' ').length.eql?(2) && t.gsub(PUNCTUATION_REGEX, '').gsub(/\'$/, '').gsub(/\.\z/, '').strip.split(' ')[1].downcase.eql?('bank')
                t.gsub(PUNCTUATION_REGEX, '').gsub(/\'$/, '').gsub(/\.\z/, '').strip.split(' ').each do |token|
                  tracker = false if corpus.include?(token.downcase)
                end
              end
              extracted_terms << t.gsub(PUNCTUATION_REGEX, '').gsub(/\'$/, '').gsub(/\.\z/, '').strip unless corpus.include?(t.downcase.gsub(PUNCTUATION_REGEX, '').gsub(/\'$/, '').strip) || !tracker || (corpus.include?(t.downcase.gsub(PUNCTUATION_REGEX, '').gsub(/\'$/, '').strip[0...-2]) && t.downcase.gsub(PUNCTUATION_REGEX, '').gsub(/\'$/, '').strip[-2..-1].eql?('en')) || (corpus.include?(t.downcase.gsub(PUNCTUATION_REGEX, '').gsub(/\'$/, '').strip[0...-2]) && t.downcase.gsub(PUNCTUATION_REGEX, '').gsub(/\'$/, '').strip[-2..-1].eql?('es')) || (corpus.include?(t.downcase.gsub(PUNCTUATION_REGEX, '').gsub(/\'$/, '').strip[0...-2]) && t.downcase.gsub(PUNCTUATION_REGEX, '').gsub(/\'$/, '').strip[-2..-1].eql?('er')) || (corpus.include?(t.downcase.gsub(PUNCTUATION_REGEX, '').gsub(/\'$/, '').strip[0...-1]) && t.downcase.gsub(PUNCTUATION_REGEX, '').gsub(/\'$/, '').strip[-1].eql?('s')) || (corpus.include?(t.downcase.gsub(PUNCTUATION_REGEX, '').gsub(/\'$/, '').strip[0...-1]) && t.downcase.gsub(PUNCTUATION_REGEX, '').gsub(/\'$/, '').strip[-1].eql?('n'))
            end
          end
        end
      end

      extracted_terms.uniq.reject(&:empty?)
    end
  end
end
