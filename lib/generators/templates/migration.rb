class InstallGreenmonster < ActiveRecord::Migration
  def self.up
    create_table "players", :force => true do |t|
      t.string   "first"
      t.string   "last"
      t.integer  "bis_id"
      t.string   "retrosheet_id"
      t.integer  "baseball_db_id"
      t.string   "baseball_prospectus_id"
      t.string   "baseball_reference_id"
      t.string   "lahman_id"
      t.integer  "westbay_id"
      t.integer  "korea_kbo_id"
      t.integer  "japan_npb_id"
      t.string   "uuid",                   :limit => 150
      t.boolean  "current"
      t.boolean  "duplicate"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
    add_index "players", ["baseball_db_id"], :name => "players-baseball_db_id"
    add_index "players", ["baseball_prospectus_id"], :name => "players-baseball_prospectus_id"
    add_index "players", ["baseball_reference_id"], :name => "players-baseball_reference_id"
    add_index "players", ["bis_id"], :name => "players-bis_id"
    add_index "players", ["japan_npb_id"], :name => "players-japan_npb_id"
    add_index "players", ["korea_kbo_id"], :name => "players-korea_kbo_id"
    add_index "players", ["lahman_id"], :name => "players-lahman_id"
    add_index "players", ["retrosheet_id"], :name => "players-retrosheet_id"
    add_index "players", ["stats_inc_id"], :name => "players-stats_inc_id"
    add_index "players", ["uuid"], :name => "players-uuid"
    add_index "players", ["westbay_id"], :name => "players-westbay_id"
  end

  def self.down
    drop_table :players
  end
end