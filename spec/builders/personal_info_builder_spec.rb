require 'spec_helper'

module RapSheetParser
  RSpec.describe PersonalInfoBuilder do
    describe '#build' do
      it 'populates the sex and name field in PersonalInfo' do
        text = <<~TEXT
          blah blah
          SEX/F
          blah blah
          NAM/01 BACCA, CHEW
              02 BACCA, CHEW E.
              03 WOOKIE, CHEWBACCA
          * * * *
          cycle text
          * * * END OF MESSAGE * * *
        TEXT

        tree = RapSheetGrammarParser.new.parse(text)

        personal_info = described_class.new(tree.personal_info).build
        expect(personal_info.sex).to eq 'F'
        expect(personal_info.names['01']).to eq 'BACCA, CHEW'
        expect(personal_info.names['02']).to eq 'BACCA, CHEW E.'
        expect(personal_info.names['03']).to eq 'WOOKIE, CHEWBACCA'

      end

      it 'returns an empty PersonalInfo if not found' do
        text = <<~TEXT
          blah blah
          * * * *
          cycle text
          * * * END OF MESSAGE * * *
        TEXT

        tree = RapSheetGrammarParser.new.parse(text)

        personal_info = described_class.new(tree.personal_info).build
        expect(personal_info).to eq nil
      end
    end
  end
end
