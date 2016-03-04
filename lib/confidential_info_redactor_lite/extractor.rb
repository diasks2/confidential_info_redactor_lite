module ConfidentialInfoRedactorLite
  # This class extracts proper nouns from a text
  class Extractor
    # Rubular: http://rubular.com/r/qE0g4r9zR7
    EXTRACT_REGEX = /(?<=\s|^|\s\"|\s\“|\s\«|\s\‹|\s\”|\s\»|\s\›)([A-Z]\S*\s)*[A-Z]\S*(?=(\s|\.|\z))|(?<=\s|^|\s\"|\s\”|\s\»|\s\›|\s\“|\s\«|\s\‹)[i][A-Z][a-z]+/

    PUNCTUATION_REGEX = /[\?\)\(\!\\\/\"\:\;\,\”\“\«\»\‹\›]/
    attr_reader :language, :corpus
    def initialize(corpus:, **args)
      @corpus = Set.new(corpus).freeze
      @language = args[:language] || 'en'
    end

    def extract(text)
      extracted_terms = []
      PragmaticSegmenter::Segmenter.new(text: text.gsub(/[’‘]/, "'"), language: language).segment.each do |segment|
        initial_extracted_terms = extract_preliminary_terms(segment)
        next if initial_extracted_terms.length.eql?(segment.split(' ').length) && search_for_ngrams(initial_extracted_terms)
        search_ngrams(initial_extracted_terms, extracted_terms)
      end
      extracted_terms.uniq.reject(&:empty?)
    end

    private

    def extract_preliminary_terms(segment)
      segment.gsub(EXTRACT_REGEX).map { |match| match unless corpus.include?(match.downcase.gsub(PUNCTUATION_REGEX, '').gsub(/\'$/, '')) }.compact
    end

    def search_for_ngrams(tokens)
      in_corpus = true
      tokens.each do |ngram|
        ngram.split(PUNCTUATION_REGEX).each do |t|
          unless corpus.include?(t.downcase.gsub(PUNCTUATION_REGEX, '').gsub(/\'$/, '').gsub(/\.\z/, '').strip)
            in_corpus = false
          end
        end
      end
      in_corpus
    end

    def search_ngrams(tokens, extracted_terms)
      tokens.each do |ngram|
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
      extracted_terms
    end
  end
end
