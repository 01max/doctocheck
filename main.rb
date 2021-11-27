# frozen_string_literal: true

require 'dotenv'
Dotenv.load

require 'yaml'
require 'faraday'
require 'discordrb'
require_relative 'lib/docto_lib'

DOCTOLIB_COLLECTIONS = YAML.safe_load(File.read('config/doctolib.yml'))['doctolib_collections'].freeze

def run_check(force_output: false, title: nil, visit_motive_ids: [], agenda_ids: [])
  availabilities = DoctoLib::RetrieveAvailabilities.new(
    start_date: Date.today,
    visit_motive_ids: visit_motive_ids,
    agenda_ids: agenda_ids
  )

  unless availabilities.previous_hash.empty?
    compared_results = DoctoLib::CompareAvailabilities.new(
      current_hash: availabilities.raw_hash,
      previous_hash: availabilities.previous_hash
    ).result_hash
  end

  return availabilities.archive! if compared_results.nil?
  return if compared_results.keys == %i[current_summary] && !force_output

  send_message(diff: compared_results, title: title)

  availabilities.archive!
end

def send_message(diff:, title: nil)
  bot_message = diff.map do |subject, diff_value|
    displayed_value = diff_value.is_a?(Hash) ? "\n`#{diff_value}`" : " : #{diff_value}"
    "__#{subject.capitalize}__#{displayed_value}"
  end.join("\n")

  bot_message = "**#{title}**\n#{bot_message}" if title

  bot = Discordrb::Bot.new(token: ENV['DISCORD_BOT_TOKEN'])
  bot.run(true)
  bot.send_message(ENV['DISCORD_CHANNEL_ID'], "@everyone \n#{bot_message}")
  bot.stop
end

def run_checks(force_output: false)
  DOCTOLIB_COLLECTIONS.each do |collection_name, collection_infos|
    run_check(
      force_output: force_output,
      title: collection_name.capitalize,
      visit_motive_ids: collection_infos['visit_motive_ids'],
      agenda_ids: collection_infos['agenda_ids']
    )
  end
end
