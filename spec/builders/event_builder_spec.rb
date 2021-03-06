require 'spec_helper'

module RapSheetParser
  RSpec.describe EventBuilder do
    it 'creates dates from date strings' do
      event = build_event('19820102')
      expect(event.date).to eq Date.new(1982, 1, 2)
    end

    it 'returns nil for invalid date strings' do
      event = build_event('19820002')
      expect(event.date).to eq nil
    end

    it 'strips stray periods from date' do
      event = build_event('198201.02')
      expect(event.date).to eq Date.new(1982, 1, 2)
    end

    class TestBuilder
      include EventBuilder

      def build
        OpenStruct.new(date: date)
      end
    end

    def build_event(text)
      event_syntax_node = double(date: double(text_value: text))
      RapSheetParser::TestBuilder.new(event_syntax_node, logger: nil).build
    end
  end
end
