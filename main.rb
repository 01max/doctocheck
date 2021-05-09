# frozen_string_literal: true

require 'dotenv'

Dotenv.load

require 'discordrb'
require_relative 'lib/docto_lib'

def run_check(force_output: false)
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

  return if compare_results.except(:current_resume).empty? && !force_output

  bot_message = compare_results.map do |key, value|
    displayed_value = value.is_a?(Hash) ? "\n`#{value}`" : " : #{value}"
    "__**#{key.capitalize}**__#{displayed_value}"
  end.join("\n")

  bot = Discordrb::Bot.new(token: ENV['DISCORD_BOT_TOKEN'])
  bot.run(true)
  bot.send_message(ENV['DISCORD_CHANNEL_ID'], "@everyone \n#{bot_message}")
  bot.stop

  availabilities.archive!
end

run_check(force_output: true)
