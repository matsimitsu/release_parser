module ReleaseParser
  class Parser

    def initialize(input_string)
      @tokenizer = Tokenizer.new(input_string)
    end

    def parse
      tokens = @tokenizer.tokenize
      Result.new(tokens)
    end
  end
end
