module Greenmonster
	module Player
    def to_s
      "#{self.first} #{self.last}"
    end
    
    def self.included(k)
      def k.create_from_gameday_xml_game(gid, args = {})
        Greenmonster::Parser.extract_players_from_game(gid, args = {}) do |p|
          player = self.find_or_initialize_by_id(p[:id])
          player.update_attributes!(p) if player.new_record?
        end
      end
    end
  end
end