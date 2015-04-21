module ConfidentialInfoRedactorLite
  # This class extracts proper nouns from a text
  class Extractor
    # Rubular: http://rubular.com/r/qE0g4r9zR7
    EXTRACT_REGEX = /(?<=\s|^|\s\")([A-Z]\S*\s)*[A-Z]\S*(?=(\s|\.|\z))|(?<=\s|^|\s\")[i][A-Z][a-z]+/
    attr_reader :text, :language, :corpus
    def initialize(text:, corpus:, **args)
      @text = text.gsub(/[’‘]/, "'")
      @corpus = corpus
      @language = args[:language] || 'en'
    end

    def extract
      extracted_terms = []
      PragmaticSegmenter::Segmenter.new(text: text, language: language).segment.each do |segment|
        initial_extracted_terms = segment.gsub(EXTRACT_REGEX).map { |match| match unless corpus.include?(match.downcase.gsub(/[\?\.\)\(\!\\\/\"\:\;]/, '').gsub(/\'$/, '')) }.compact
        initial_extracted_terms.each do |ngram|
          ngram.split(/[\?\)\(\!\\\/\"\:\;\,]/).each do |t|
            if corpus.include?(t.downcase.gsub(/[\?\)\(\!\\\/\"\:\;\,]/, '').gsub(/\'$/, '').gsub(/\.\z/, '').strip.split(' ')[0]) && t.downcase.gsub(/[\?\)\(\!\\\/\"\:\;\,]/, '').gsub(/\'$/, '').gsub(/\.\z/, '').strip.split(' ')[0] != 'the'
              extracted_terms << t.gsub(/[\?\)\(\!\\\/\"\:\;\,]/, '').gsub(/\'$/, '').gsub(/\.\z/, '').strip.split(' ')[1] unless corpus.include?(t.downcase.gsub(/[\?\.\)\(\!\\\/\"\:\;]/, '').gsub(/\'$/, '').strip.split(' ')[1])
            else
              extracted_terms << t.gsub(/[\?\)\(\!\\\/\"\:\;\,]/, '').gsub(/\'$/, '').gsub(/\.\z/, '').strip unless corpus.include?(t.downcase.gsub(/[\?\.\)\(\!\\\/\"\:\;]/, '').gsub(/\'$/, '').strip)
            end
          end
        end
      end

      if language.eql?('de')
        extracted_terms.delete_if do |token|
          corpus.include?(token.split(' ')[0].downcase.strip) &&
            token.split(' ')[0].downcase.strip != 'deutsche'
        end.uniq.reject(&:empty?)
      else
        extracted_terms.uniq.reject(&:empty?)
      end
    end
  end
end
