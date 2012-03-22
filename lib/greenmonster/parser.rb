module Greenmonster
  module Parser
    def self.load_line_score(gid, args = {})
      Nokogiri::XML(File.open(game_path(gid, args) + 'linescore.xml')).search("game").first
    rescue
      false
    end 
    
    def self.extract_players_from_game(gid, args = {})
      Nokogiri::XML(open(game_path(gid,args) + 'players.xml')).search('player').each do |p|
        hash = {:id => p.attribute('id').value.to_i, :first => p.attribute('first').value, :last => p.attribute('last').value}
        yield hash
      end
    end
    
    def self.game_path(gid,args)
      game_path = Pathname.new(args[:games_folder] || Greenmonster.games_folder)
      game_path += args[:sport_code] || gid[25,3]
      game_path += Greenmonster.format_date_as_folder(date_from_game_id(gid))
      game_path += gid
    end
    
    def self.date_from_game_id(gid)
      Date.new(gid[4,4].to_i, gid[9,2].to_i, gid[12,2].to_i)
    end
  end
end