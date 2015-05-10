module Greenmonster
  class DaySpider
    def initialize(date:, sport_code: "mlb")
      @date = date
      @sport_code = sport_code
    end

    def pull
      game_ids_for_date.each do |game_id|
        Greenmonster::GameSpider.
          new(sport_code: sport_code, game_id: game_id).
          pull
      end
    end

    protected

    attr_reader :date, :sport_code

    private

    def date_path
      "#{sport_code}/year_#{year}/month_#{month}/day_#{day}"
    end

    def fetch_game_list
      HTTParty.
        get("#{Greenmonster::REMOTE_DATA_ROOT}/#{date_path}").
        response.
        body
    end

    def html_links
      Nokogiri::HTML(fetch_game_list).search("a")
    end

    def game_links_for_date
      html_links.select do |link|
        link.text.strip[0..3] == "gid_"
      end
    end

    def game_ids_for_date
      game_links_for_date.map do |link|
        link.text.strip.gsub("/", "")
      end
    end

    def year
      date.strftime("%Y")
    end

    def month
      date.strftime("%m")
    end

    def day
      date.strftime("%d")
    end
  end
end
