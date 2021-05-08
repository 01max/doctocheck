# frozen_string_literal: true

require 'open-uri'
require 'json'

# Doctolib interactions
module DoctoLib
  HOST = 'www.doctolib.fr'

  # Availabilities get & parse
  class Availabilities
    PATH = '/availabilities.json'

    # TODO: remove
    attr_reader :raw_hash

    def initialize(visit_motive_ids:, agenda_ids:, start_date: Date.today, limit: 3)
      @start_date = start_date.to_s
      @visit_motive_ids = visit_motive_ids
      @agenda_ids = agenda_ids
      @limit = limit

      retrieve
    end

    def retrieve
      json_url = build_url
      @raw_json = URI.parse(json_url).read
      # @raw_json = File.read('dev_tools/doctolib_availabilities_example.json')
      @raw_hash = JSON.parse(raw_json)
    end

    def archive!
      retrieve unless raw_json

      return if previous_response == raw_json

      File.open(data_file_path, 'w') do |data_file|
        data_file.write(raw_json)
      end
    end

    def previous_response
      return {} unless File.exist?(data_file_path)

      JSON.parse(File.read(data_file_path))
    rescue JSON::ParserError
      {}
    end

    private

    attr_reader :start_date, :visit_motive_ids, :agenda_ids, :limit, :raw_json

    def build_url
      URI::HTTPS.build(
        host: HOST,
        path: PATH,
        query: URI.encode_www_form(url_arguments)
      ).to_s
    end

    def url_arguments
      {
        start_date: start_date,
        visit_motive_ids: visit_motive_ids.join('-'),
        agenda_ids: agenda_ids.join('-'),
        limit: limit
      }
    end

    def unique_file_name
      [agenda_ids.sort.join('-'), 'json'].join('.')
    end

    def data_file_path
      "/data/#{unique_file_name}"
    end
  end
end
