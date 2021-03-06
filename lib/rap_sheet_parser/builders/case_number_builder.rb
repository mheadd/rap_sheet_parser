module RapSheetParser
  class CaseNumberBuilder
    def initialize(case_number_node)
      @case_number_node = case_number_node
    end

    def build
      return if case_number_node.nil?

      stripped_case_number = case_number_node.text_value.delete(' ').delete('.')[1..-1]
      strip_trailing_punctuation(stripped_case_number)
    end

    private

    attr_reader :case_number_node

    def strip_trailing_punctuation(str)
      new_str = str

      while new_str.end_with?('.', ':', '-')
        new_str = new_str[0..-2]
      end
      new_str
    end
  end
end
