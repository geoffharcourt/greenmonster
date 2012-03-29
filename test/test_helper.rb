require "sqlite3"
require "supermodel"
require 'minitest/autorun'
require 'greenmonster'

ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => './test/test.db'
)

class CreateSchema < ActiveRecord::Migration
  def self.up
    create_table :athletes, :force => true do |t|
      t.string  :first
      t.string  :last
    end

    create_table :gameday_games, :force => true do |t|
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

    create_table :probable_pitchers, :force => true  do |t|
      t.integer "game_pk"
      t.date "date"
      t.integer "player_id"
      t.string "side"
    end
  end
end

CreateSchema.suppress_messages { CreateSchema.migrate(:up) }

class Athlete < ActiveRecord::Base
  include Greenmonster::Player
end

class GamedayGame < ActiveRecord::Base
  include Greenmonster::MlbGame
end

class ProbablePitcher < ActiveRecord::Base
  include Greenmonster::MlbProbablePitcher
end

Greenmonster.set_games_folder('./test/games')
FileUtils.mkdir_p Greenmonster.games_folder
