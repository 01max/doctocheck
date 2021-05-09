# frozen_string_literal: true

module DoctoLib
  # Availabilities get & parse
  class RetrieveAvailabilities
    HOST = 'www.doctolib.fr'
    PATH = '/availabilities.json'

    attr_reader :raw_hash

    def initialize(visit_motive_ids:, agenda_ids:, start_date: Date.today, limit: 3)
      @start_date = start_date.to_s
      @visit_motive_ids = visit_motive_ids
      @agenda_ids = agenda_ids
      @limit = limit

      process
    end

    def process
      json_url = build_url
      @raw_json = URI.parse(json_url).read
      @raw_hash = JSON.parse(raw_json)
    end

    def archive!
      process unless raw_json

      return if previous_hash == raw_json

      File.open(data_file_path, 'w') do |data_file|
        data_file.write(raw_json)
      end

      true
    rescue
      false
    end

    def previous_hash
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
