require 'minitest/autorun'
require 'greenmonster'
require 'supermodel'

class GamedayGame < SuperModel::Base
  include Greenmonster::MlbGame
  
  def self.find_or_initialize_by_id(id_number)
    begin
      a = self.find(id_number)
    rescue
    end
    
    if a.nil?
      return self.find_or_create_by_id(id_number)
    else
      return a
    end
  end
end

class TestCreateMlbGameFromGamedayXMLGame < MiniTest::Unit::TestCase
  def test_create_players_from_gameday_xml_game
    GamedayGame.create_from_gameday_xml_game('gid_2011_07_04_tormlb_bosmlb_1')
    assert_equal 1, GamedayGame.all.count
  end
  
  def setup
    Greenmonster.set_games_folder('./greenmonster_test_games')
    FileUtils.mkdir_p Greenmonster.games_folder
    Greenmonster::Spider.pull_game('gid_2011_07_04_tormlb_bosmlb_1', {:print_games => false})
  end
  
  def teardown
    FileUtils.remove_dir Greenmonster.games_folder
  end
end
