module RapSheetParser
  module EventGrammar
    class Event < Treetop::Runtime::SyntaxNode; end

    class CourtEvent < Event
      def case_number
        counts[0].case_number if counts[0].is_a? CountWithCaseNumber
      end

      def sentence
        count = counts.find { |c| c.disposition.sentence }

        return unless count

        count.disposition.sentence
      end

      def is_conviction?
        counts.any? { |c| c.disposition.disposition_type.is_a? CountGrammar::Convicted }
      end
    end

    class Count < Treetop::Runtime::SyntaxNode
      def disposition
        count_content.disposition
      end

      def code_section
        count_content.code_section
      end

      def code_section_description
        count_content.code_section_description
      end

      def count_content
        return @count_content if @count_content

        @count_content = do_parsing(CountGrammarParser.new, count_info.text_value + "\n")
      end
    end

    class Update < Treetop::Runtime::SyntaxNode
      def dispositions
        update_content.dispositions.elements
      end

      def update_content
        return @update_content if @update_content

        @update_content = do_parsing(UpdateGrammarParser.new, update_info.text_value + "\n")
      end
    end

    class CountWithCaseNumber < Count; end
    class ArrestEvent < Event; end
    class CustodyEvent < Event; end
    class RegistrationEvent < Event; end
  end
end
