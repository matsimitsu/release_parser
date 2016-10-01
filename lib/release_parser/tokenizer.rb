module ReleaseParser
  class Tokenizer
    attr_reader :input_string, :tokens, :chars, :position

    def initialize(input_string)
      @input_string = input_string
      @tokens = []
      @chars = []
      @position = 0
      @unknown = []
    end

    def tokenize
      loop do
        break if @position >= input_string.length

        # Get characters from current position onward
        chars = @input_string[@position..(@input_string.length)]

        # See if we can match something at the beginning of current part
        case chars
        when match = Tokens::Resolution.new
          add_token(match)
        when match = Tokens::Source.new
          add_token(match)
        when match = Tokens::Codec.new
          add_token(match)
        when match = Tokens::Season.new
          add_token(match)
        when match = Tokens::Episode.new
          add_token(match)
        when match = Tokens::ReleaseGroup.new
          add_token(match)
        when match = Tokens::Airdate.new
          add_token(match)
        when match = Tokens::Year.new
          add_token(match)
        when match = Tokens::Audio.new
          add_token(match)
        when match = Tokens::Separator.new
          add_token(match)
        when match = Tokens::Language.new
          add_token(match)
        when match = Tokens::Country.new
          add_token(match)
        when match = Tokens::Freeleech.new
          add_token(match)

        # Otherwise, add the current character to the "unknown" pile
        else
          @unknown << chars[0]
          @position += 1
        end
      end

      # Handle the left unknown pile
      process_unknown
      tokens
    end

    # Add found token to the list and update the position,
    # based on found length
    def add_token(token)
      process_unknown
      @tokens << token
      @position += token.length
    end

    # Handle the unknown pile,
    # create a token from it and clear the pile
    def process_unknown
      if @unknown.any?
        unknown_token = Tokens::Unknown.new(@unknown.join)
        @tokens << Tokens::Unknown.new(@unknown.join)
        @unknown = []
      end
    end
  end
end
