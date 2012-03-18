class CreateGreenmonsterPlayers < ActiveRecord::Migration
  def self.up
    create_table "players", :force => true do |t|
      t.string   "first"
      t.string   "last"
      t.boolean  "current"
      t.integer  "bis_id"
      t.string   "retrosheet_id"
      t.integer  "stats_inc_id"
      t.integer  "baseball_db_id"
      t.string   "baseball_prospectus_id"
      t.string   "lahman_id"
      t.integer  "westbay_id"
      t.integer  "korea_kbo_id"
      t.integer  "japan_npb_id"
      t.string   "baseball_reference_id"
      t.string   "uuid",                   :limit => 150
      t.boolean  "duplicate"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
  end

  def self.down
    drop_table :team_members
  end
end