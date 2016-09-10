module ReleaseParser
  class Result
    def self.field(name, tokens, options={})
      define_method(name) do
         val_from_token(Array(tokens), options)
      end
    end

    field :season,        ReleaseParser::Tokens::Season
    field :episode,       ReleaseParser::Tokens::Episode
    field :codec,         ReleaseParser::Tokens::Codec
    field :source,        ReleaseParser::Tokens::Source
    field :resolution,    ReleaseParser::Tokens::Resolution
    field :release_group, ReleaseParser::Tokens::ReleaseGroup
    field :year,          ReleaseParser::Tokens::Year
    field :audio,         ReleaseParser::Tokens::Audio,       :multi => true
    field :language,      ReleaseParser::Tokens::Language,    :multi => true
    field :freeleech,     ReleaseParser::Tokens::Freeleech

    def initialize(tokens)
      @tokens = tokens
    end

    # Loop through all tokens, and stop if we encounter something that isn't
    # a separator, year or unknown token.
    def title
      title_tokens = []
      @tokens.each do |token|
        break unless [
          ReleaseParser::Tokens::Unknown,
          ReleaseParser::Tokens::Separator
        ].include? token.class

        title_tokens << token
      end
      title_tokens.map(&:normalized_result).join.strip
    end

    def freeleech?
      freeleech == true
    end

    # Find field value based on given token class
    # if options[:multi] is true, return all results
    def val_from_token(token_classes=[], options={})
      res = Array(token_classes).map do |tc|
        @tokens.find { |t| t.class == tc }
      end.compact

      if options[:multi]
        res.map(&:normalized_result)
      else
        res.first ? res.first.normalized_result : nil
      end
    end
  end
end
