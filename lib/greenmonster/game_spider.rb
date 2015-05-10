module Greenmonster
  class GameSpider
    def initialize(game_id:, sport_code: "mlb")
      @game_id = game_id
      @sport_code = sport_code
    end

    def pull
      make_folder
      download_xml
    end

    protected

    attr_reader :game_id, :sport_code

    private

    def make_folder
      FileUtils.
        mkdir_p("#{Greenmonster.local_data_location}/games/#{game_path}/inning")
    end

    def download_xml
      download_innings
      download_hit_locations
      download_boxscore
      download_linescore
      download_players
    end

    def game_path
      "#{sport_code}/year_#{year}/month_#{month}/day_#{day}/#{game_id}"
    end

    def download_boxscore
      Greenmonster::FileDownloader.
        new(game_path: game_path, file_name: "boxscore.xml").
        pull
    end

    def download_hit_locations
      Greenmonster::FileDownloader.
        new(game_path: game_path, file_name: "inning/inning_hit.xml").
        pull
    end

    def download_innings
      if year.to_i >= 2008
        download_all_innings_as_one_file
      else
        download_each_inning_file
      end
    end

    def download_all_innings_as_one_file
      Greenmonster::FileDownloader.
        new(game_path: game_path, file_name: "inning/inning_all.xml").
        pull
    end

    def download_each_inning_file
      Greenmonster::InningsDownloader.new(game_path: game_path).pull
    end

    def download_linescore
      Greenmonster::FileDownloader.
        new(game_path: game_path, file_name: "linescore.xml").
        pull
    end

    def download_players
      Greenmonster::FileDownloader.
        new(game_path: game_path, file_name: "players.xml").
        pull
    end

    protected

    attr_reader :date, :game_number, :sport_code

    private

    def date_segments
      @date_segments ||= game_id.split("_")
    end

    def year
      @year ||= date_segments[1]
    end

    def month
      @month ||= date_segments[2]
    end

    def day
      @day ||= date_segments[3]
    end
  end
end
