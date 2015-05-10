module Greenmonster
  class InningsDownloader
    def initialize(game_path:)
      @game_path = game_path
    end

    def pull
      inning_names.each do |inning_name|
        Greenmonster::FileDownloader.new(
          game_path: game_path,
          file_name: "inning/#{inning_name}"
        ).pull
      end
    end

    protected

    attr_reader :game_path

    private

    def inning_names
      relevant_links.map do |link|
        link.text.strip.gsub("/", "")
      end
    end

    def innings_listing_html
      HTTParty.
        get("#{Greenmonster::REMOTE_DATA_ROOT}/#{game_path}/inning").
        response.
        body
    end

    def relevant_links
      Nokogiri::HTML(innings_listing_html).search("a").select do |link|
        link.text =~ /inning_\d+\.xml/
      end
    end
  end
end
