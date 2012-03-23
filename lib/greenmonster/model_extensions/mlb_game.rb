module Greenmonster
	module MlbGame
    def to_s
      "Game #{self.game_pk}: #{self.game_id[15,6]} @ #{self.game_id[22,6]}"
    rescue
      "Game #{self.game_pk}: (Game ID not valid.)"
    end
    
    def update_with_line_score_data(line_score)
      # Set Game Primary Key
      self.game_pk = line_score.attributes['game_pk'].value.to_i
      self.game_id = if line_score.has_attribute?('gameday_link')
        line_score.attribute('gameday_link').value.gsub('_','')
      elsif line_score.has_attribute?('id') 
        line_score.attribute('id').value.gsub('/','').gsub('-','')
      else
        raise "Unknown game_id, need new method for game."
      end
    
      self.game_num = self.game_id[20].to_i
      
      # Set date
      self.date = case
      when line_score.attributes['id']
        Date.new(
          line_score.attributes['id'].value[0,4].to_i,
          line_score.attributes['id'].value[5,2].to_i,
          line_score.attributes['id'].value[8,2].to_i
        )
      when line_score.attributes['gameday_link']
        Date.new(
          line_score.attributes['gameday_link'].value[0,4].to_i,
          line_score.attributes['gameday_link'].value[5,2].to_i,
          line_score.attributes['gameday_link'].value[8,2].to_i
        )
      else
        Date.new(0000,00,00)
      end
    
      # Set start time
      if line_score.attributes['time'] and line_score.attributes['time'].value.include?(':')
        self.game_time = Time.parse("#{self.date} #{line_score.attributes['time'].value} #{line_score.attributes['ampm']}")
      else
        self.game_time = Time.new(self.date.year,self.date.month,self.date.day,19,30)
      end
    
      # Set game status and type
      self.game_status = line_score.attributes['ind'].value if line_score.attributes['ind']
      self.game_type = line_score.attributes['game_type'].value if line_score.attributes['game_type']
    
      # Set venue information
      if line_score and line_score.attributes["venue"] and line_score.attributes["venue"].value and line_score.attributes['venue_id']
        self.venue_id = line_score.attributes['venue_id'].value.to_i
        self.game_venue = line_score.attributes['venue'].value
      end
    
      # Set leagues
      self.home_league_id = line_score.attributes["home_league_id"].value.to_i if line_score.attributes["home_league_id"]
      self.away_league_id = line_score.attributes["away_league_id"].value.to_i if line_score.attributes["away_league_id"]
  
      # Set divisions
      self.home_division = line_score.attributes["home_division"].value if line_score.attributes["home_division"]
      self.away_division = line_score.attributes["away_division"].value if line_score.attributes["away_division"]

      # Set sport codes
      self.home_sport_code = line_score.attributes["home_sport_code"].value if line_score.attributes["home_sport_code"]
      self.away_sport_code = line_score.attributes["away_sport_code"].value if line_score.attributes["away_sport_code"]
      self.sport_code = self.home_sport_code
    
      # Set teams
      self.home_team_id = line_score.attributes["home_team_id"].value.to_i if line_score.attributes["home_team_id"]
      self.away_team_id = line_score.attributes["away_team_id"].value.to_i if line_score.attributes["away_team_id"]
    
      return self.save
    end
    
    
    def self.included(k)
      def k.create_from_gameday_xml_game(gid, args = {})
        line_score = Greenmonster::Parser.load_line_score(gid, args)
        
        if line_score
          game = self.find_or_initialize_by_id(line_score.attributes["game_pk"].value.to_i)
        
          game.save!
          return game
        else
          return false
        end
      end
    end
	end
end