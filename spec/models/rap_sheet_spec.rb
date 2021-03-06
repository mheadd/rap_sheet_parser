require 'spec_helper'

module RapSheetParser
  RSpec.describe RapSheet do
    describe '#sex_offender_registration?' do
      it 'returns true if registration event containing PC 290' do
        event = RegistrationEvent.new(
          date: nil,
          code_section: 'PC 290'
        )

        rap_sheet = build_rap_sheet(events: [event])
        expect(rap_sheet.sex_offender_registration?).to eq true
      end

      it 'returns true if registration event starting with PC 290' do
        event = RegistrationEvent.new(
          date: nil,
          code_section: 'PC 290(a)'
        )

        rap_sheet = build_rap_sheet(events: [event])
        expect(rap_sheet.sex_offender_registration?).to eq true
      end

      it 'returns false if no registration event containing PC 290' do
        event = RegistrationEvent.new(
          date: nil,
          code_section: 'HS 11590'
        )

        rap_sheet = build_rap_sheet(events: [event])
        expect(rap_sheet.sex_offender_registration?).to eq false
      end

      it 'returns false if no registration event containing PC 290' do
        event = RegistrationEvent.new(
          date: nil,
          code_section: 'HS 11590'
        )

        rap_sheet = build_rap_sheet(events: [event])
        expect(rap_sheet.sex_offender_registration?).to eq false
        expect(rap_sheet.narcotics_offender_registration?).to eq true
      end
    end

    describe '#arrests' do
      it 'returns arrests' do
        arrest = ArrestEvent.new(date: Date.today, counts: [])
        custody = CustodyEvent.new(date: Date.today)

        rap_sheet = build_rap_sheet(events: [arrest, custody])
        expect(rap_sheet.arrests[0]).to eq arrest
      end
    end

    describe '#superstrikes' do
      it 'returns any superstrike convictions' do
        count = build_court_count(code: 'PC', section: '187', disposition: 'convicted')
        conviction = build_conviction_event(counts: [count])

        rap_sheet = build_rap_sheet(events: [conviction])
        expect(rap_sheet.superstrikes).to contain_exactly(count)
      end

      it 'returns empty list if no superstrike convictions' do
        count = build_court_count(code: 'PC', section: '187', disposition: 'dismissed')
        conviction = build_conviction_event(counts: [count])

        rap_sheet = build_rap_sheet(events: [conviction])
        expect(rap_sheet.superstrikes).to be_empty
      end
    end
  end
end
