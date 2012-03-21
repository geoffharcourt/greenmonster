module Greenmonster
	module MlbGame
    def to_s
      "Game #{self.game_pk}: #{self.game_id[15,6]} @ #{self.game_id[22,6]}"
    rescue
      "Game #{self.game_pk}: (Game ID not valid.)"
    end
    
    def self.included(k)
      def k.create_from_gameday_xml_game(gid, args = {})
        Greenmonster::Parser.create_mlb_game(gid, args = {})
      end
    end
    
	end
end