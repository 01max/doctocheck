# frozen_string_literal: true

module DoctoLib
  # Availabilities comparison
  class CompareAvailabilities
    attr_reader :result_hash

    def initialize(current_hash:, previous_hash: {})
      @current_hash = current_hash
      @previous_hash = previous_hash

      process
    end

    def process
      @result_hash = {}

      compare_totals
      compare_next_slots
      compare_date_slots
    end

    private

    attr_reader :current_hash, :previous_hash
    attr_writer :result_hash

    def compare_totals
      return unless current_hash['total'] != previous_hash['total']

      result_hash[:total_diff] = current_hash['total'] - previous_hash['total']
    end

    def compare_next_slots
      return unless current_hash['next_slot']
      return unless current_hash['next_slot'] != previous_hash['next_slot']

      result_hash[:new_next_slot] = current_hash['next_slot']
    end

    def compare_date_slots
      result_hash[:slots_count_diff] = {}

      current_hash['availabilities'].each do |current_date_availabilities|
        date = current_date_availabilities['date']
        previous_date_availabilities = previous_hash['availabilities'].select { |avb| avb['date'] == date }.first
        previous_slots_count = previous_date_availabilities['slots'].to_a.length
        current_slots_count = current_date_availabilities['slots'].to_a.length

        next unless current_slots_count != previous_slots_count

        result_hash[:slots_count_diff][date] = current_slots_count - previous_slots_count
      end

      result_hash.delete(:slots_count_diff) if result_hash[:slots_count_diff].empty?
    end
  end
end