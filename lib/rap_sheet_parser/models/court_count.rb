module RapSheetParser
  class CourtCount < ApplicationRecord
    SUPERSTRIKES = [
      'PC 187',
      'PC 191.5',
      'PC 209',
      'PC 220',
      'PC 245(d)(3)',
      'PC 261(a)(2)',
      'PC 261(a)(6)',
      'PC 262(a)(2)',
      'PC 262(a)(4)',
      'PC 264.1',
      'PC 269',
      'PC 286(c)(1)',
      'PC 286(c)(2)(a)',
      'PC 286(c)(2)(b)',
      'PC 286(c)(2)(c)',
      'PC 286(c)(3)',
      'PC 286(d)(1)',
      'PC 286(d)(2)',
      'PC 286(d)(3)',
      'PC 288(a)',
      'PC 288(b)(1)',
      'PC 288(b)(2)',
      'PC 288a(c)(1)',
      'PC 288a(c)(2)(a)',
      'PC 288a(c)(2)(b)',
      'PC 288a(c)(2)(c)',
      'PC 288a(d)',
      'PC 288.5(a)',
      'PC 289(a)(1)(a)',
      'PC 289(a)(1)(b)',
      'PC 289(a)(1)(c)',
      'PC 289(a)(2)(c)',
      'PC 289(j)',
      'PC 653f',
      'PC 11418(a)(1)'
    ].freeze

    def severity_felony
      where(severity: 'F')
    end

    def severity_misdemeanor
      where(severity: 'M')
    end

    def severity_unknown
      where(severity: nil)
    end

    def long_severity
      case severity
      when 'F'
        'felony'
      when 'M'
        'misdemeanor'
      when 'I'
        'infraction'
      else
        'unknown'
      end
    end

    def code_section
      return unless code && section
      "#{code} #{section}"
    end

    def superstrike?
      return false unless code_section

      SUPERSTRIKES.include? code_section
    end

    def code_section_starts_with(codes)
      return false unless code_section

      codes.any? do |d|
        code_section.start_with? d
      end
    end
  end
end
