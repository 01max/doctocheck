# frozen_string_literal: true

require_relative 'lib/docto_lib'

avb = DoctoLib::Availabilities.new(
  start_date: '2021-05-11',
  visit_motive_ids: %w[2542516],
  agenda_ids: %w[445302 457249 413635 426805 464787]
)
