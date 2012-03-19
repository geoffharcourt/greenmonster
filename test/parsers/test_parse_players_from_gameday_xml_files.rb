require 'minitest/autorun'
require 'greenmonster'
require 'date'

class ParsePlayersFromGamedayXMLFiles < MiniTest::Unit::TestCase
  def setup
    Greenmonster.set_games_folder('./greenmonster_test_games')
    FileUtils.mkdir_p Greenmonster.games_folder
    Greenmonster::Spider.pull_game('gid_2011_07_04_tormlb_bosmlb_1', {:print_games => false})
  end
  
  def test_parse_players_from_game
    players = []
    Greenmonster::Parser.extract_players_from_game('gid_2011_07_04_tormlb_bosmlb_1') do |p|
      players << p
    end
    players.sort!{|x,y| x[:id] <=> y[:id]}
    
    assert_equal 50, players.count
  end
  
  def test_player_ids_stored_as_integers
    players = []
    Greenmonster::Parser.extract_players_from_game('gid_2011_07_04_tormlb_bosmlb_1') do |p|
      players << p
    end
    assert players.first[:id].kind_of? Integer
  end

  def teardown
    FileUtils.remove_dir Greenmonster.games_folder
  end
end
