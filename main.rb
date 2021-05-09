# frozen_string_literal: true

require_relative 'lib/docto_lib'

availabilities = DoctoLib::RetrieveAvailabilities.new(
  start_date: Date.today,
  visit_motive_ids: %w[2542516],
  agenda_ids: %w[445302 457249 413635 426805 464787]
)

unless availabilities.previous_hash.empty?
  compare_results = DoctoLib::CompareAvailabilities.new(
    current_hash: availabilities.raw_hash,
    previous_hash: availabilities.previous_hash
  ).result_hash
end

puts "compare_results : #{compare_results}"

# availabilities.archive!
