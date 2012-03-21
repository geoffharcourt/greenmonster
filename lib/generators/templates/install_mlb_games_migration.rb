class InstallMlbGames < ActiveRecord::Migration
  def self.up
	  create_table "mlb_games", :force => true do |t|
    	t.date     "date"
    	t.datetime "created_at"
    	t.datetime "updated_at"
    	t.string   "away_division"
    	t.string   "home_division"
    	t.string   "game_id"
    	t.string   "game_location"
    	t.integer  "game_num"
    	t.integer  "game_pk"
    	t.string   "game_status",              :limit => 2
    	t.datetime "game_time"
    	t.boolean  "game_time_is_tbd"
    	t.integer  "game_time_offset_eastern"
    	t.integer  "game_time_offset_local"
    	t.string   "game_type",                :limit => 1
    	t.string   "game_venue"
    	t.boolean  "is_suspension_resumption"
    	t.boolean  "mlbtv"
    	t.string   "preview"
    	t.integer  "resumptionTime",           :limit => 8
    	t.datetime "scheduledTime"
    	t.string   "sport_code",               :limit => 3
    	t.integer  "venue_id"
    	t.string   "video_uri"
    	t.string   "wrapup"
    	t.boolean  "game_dh"
    	t.integer  "away_team_id"
    	t.integer  "home_team_id"
    	t.integer  "away_league_id"
    	t.integer  "home_league_id"
    	t.string   "away_sport_code"
    	t.string   "home_sport_code"
    	t.integer  "last_event_processed"
    end

  	add_index "mlb_games", ["away_league_id"], :name => "mlb_games-away_league_id"
  	add_index "mlb_games", ["away_team_id"], :name => "mlb_games-away_team_id"
  	add_index "mlb_games", ["date"], :name => "mlb_games-date"
  	add_index "mlb_games", ["game_id", "game_type"], :name => "mlb_games-game_id-game_type"
  	add_index "mlb_games", ["game_id"], :name => "mlb_games-game_id"
  	add_index "mlb_games", ["game_pk"], :name => "mlb_games-game_pk", :unique => true
  	add_index "mlb_games", ["home_division"], :name => "mlb_games-division_id"
  	add_index "mlb_games", ["home_league_id"], :name => "mlb_games-home_league_id"
  	add_index "mlb_games", ["home_team_id"], :name => "mlb_games-home_team_id"
  	add_index "mlb_games", ["venue_id"], :name => "mlb_games-venue_id"
	end
	
	def self.down
		drop_table :mlb_games
	end
end