# frozen_string_literal: true

module DoctoLib
  # Availabilities comparison
  class CompareAvailabilities
    attr_reader :result_hash, :current_summary

    class << self
      def build_diff_message(current:, previous:)
        raw_diff = current - previous
        raw_diff = "+#{raw_diff}" if raw_diff > 0
        "#{raw_diff} (is #{current}, was #{previous})"
      end
    end

    def initialize(current_hash:, previous_hash: {})
      @current_hash = current_hash
      @previous_hash = previous_hash

      process
    end

    def process
      @result_hash = {}
      @current_summary = {}

      compare_totals
      compare_next_slots
      compare_date_slots

      result_hash[:current_summary] = current_summary
    end

    private

    attr_reader :current_hash, :previous_hash
    attr_writer :result_hash, :current_summary

    def compare_totals
      current_summary[:total] = current_hash['total']
      return unless current_hash['total'] != previous_hash['total']

      diff_message = self.class.build_diff_message(current: current_hash['total'], previous: previous_hash['total'])
      result_hash[:total_diff] = diff_message
    end

    def compare_next_slots
      current_summary[:next_slot] = current_hash['next_slot']
      return unless current_hash['next_slot']
      return unless current_hash['next_slot'] != previous_hash['next_slot']

      result_hash[:new_next_slot] = "#{current_hash['next_slot']} (was #{previous_hash['next_slot']})"
    end

    def compare_date_slots
      result_hash[:slots_count_diff] = {}
      current_summary[:slots_count] = {}

      current_hash['availabilities'].each do |current_date_availabilities|
        date = current_date_availabilities['date']
        previous_date_availabilities = previous_hash['availabilities'].select { |avb| avb['date'] == date }.first

        previous_slots_count = previous_date_availabilities.nil? ? 0 : previous_date_availabilities['slots'].to_a.length
        current_slots_count = current_date_availabilities['slots'].to_a.length

        current_summary[:slots_count][date] = current_slots_count

        next unless current_slots_count != previous_slots_count

        diff_message = self.class.build_diff_message(current: current_slots_count, previous: previous_slots_count)
        result_hash[:slots_count_diff][date] = diff_message
      end

      result_hash.delete(:slots_count_diff) if result_hash[:slots_count_diff].empty?
    end
  end
end
