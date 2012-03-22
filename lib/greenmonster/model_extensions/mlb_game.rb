module Greenmonster
	module MlbGame
    
    def to_s
      "Game #{self.game_pk}: #{self.game_id[15,6]} @ #{self.game_id[22,6]}"
    rescue
      "Game #{self.game_pk}: (Game ID not valid.)"
    end
    
    def self.included(k)
      def k.create_from_gameday_xml_game(gid, args = {})
        line_score = Greenmonster::Parser.load_line_score(gid, args)
        
        if line_score
          game = self.find_or_initialize_by_id(line_score.attributes["game_pk"].value.to_i)
        else
          false
        end
      end
    end
	end
end