module RapSheetParser
  module CountGrammar
    class Count < Treetop::Runtime::SyntaxNode
      def code_section
        if charge_line.is_a? CodeSectionLine
          charge_line.code_section
        elsif charge_line.is_a? SeeCommentForCharge
          if disposition.disposition_type.is_a? Convicted
            comment_charge_line = disposition.disposition_info.select do |l|
              l.is_a? CommentChargeLine
            end

            comment_charge_line.first.code_section unless comment_charge_line.empty?
          end
        end
      end

      def code_section_description
        if charge_line.is_a? CodeSectionLine
          charge_line.code_section_description
        end
      end
    end

    class Disposition < Treetop::Runtime::SyntaxNode
      def severity
        disposition_info.find { |l| l.is_a? SeverityLine }&.severity
      end

      def sentence
        @sentence ||= begin
          if sentence_line
            sentence_text = TextCleaner.clean_sentence(sentence_line.sentence.text_value)
            do_parsing(SentenceGrammarParser.new, sentence_text)
          end
        end
      end

      private

      def sentence_line
        disposition_info.find do |l|
          l.is_a? SentenceLine or l.is_a? CommentSentenceLine
        end
      end
    end

    class SeeCommentForCharge < Treetop::Runtime::SyntaxNode; end
    class Convicted < Treetop::Runtime::SyntaxNode; end
    class Dismissed < Treetop::Runtime::SyntaxNode; end
    class OtherDispositionType < Treetop::Runtime::SyntaxNode; end
    class ProsecutorRejected < Treetop::Runtime::SyntaxNode; end

    class CodeSectionLine < Treetop::Runtime::SyntaxNode; end

    class SeverityLine < Treetop::Runtime::SyntaxNode; end

    class CommentChargeLine < Treetop::Runtime::SyntaxNode; end

    class CommentSentenceLine < Treetop::Runtime::SyntaxNode; end

    class SentenceLine < Treetop::Runtime::SyntaxNode; end
  end
end
