#encoding: utf-8

module Greenmonster
  class FileDownloader
    def initialize(file_name:, game_path:)
      @file_name = file_name
      @game_path = game_path
    end

    def pull
      return false if fetch.code != "200"

      write_file
    end

    protected

    attr_reader :file_name, :game_path

    private

    def fetch
      @fetch ||= HTTParty.get(remote_path).response
    end

    def local_path
      "#{Greenmonster.local_data_location}/games/#{game_path}/#{file_name}"
    end

    def remote_path
      "#{Greenmonster::REMOTE_DATA_ROOT}/#{game_path}/#{file_name}"
    end

    def encoded_response
      fetch.body.force_encoding("utf-8")
    end

    def write_file
      File.open(local_path, "w") do |file|
        file.write(encoded_response)
      end
    end
  end
end
