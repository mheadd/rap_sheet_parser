module RapSheetParser
  class RapSheet
    attr_reader :events

    def initialize(events)
      @events = events
    end

    def convictions
      filtered_events(ConvictionEvent)
    end

    def arrests
      filtered_events(ArrestEvent)
    end

    def custody_events
      filtered_events(CustodyEvent)
    end

    def registration_events
      filtered_events(RegistrationEvent)
    end

    def superstrikes
      @superstrikes ||= convictions.
        flat_map(&:counts).
        select(&:superstrike?)
    end

    def sex_offender_registration?
      registration_event_with_code('PC 290')
    end
    
    def narcotics_offender_registration?
      registration_event_with_code('HS 11590')
    end

    private

    def registration_event_with_code(code)
      registration_events.
        map(&:code_section).
        include?(code)
    end

    def filtered_events(klass)
      events.select { |e| e.is_a? klass }
    end
  end
end