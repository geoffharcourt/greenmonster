require './test/test_helper.rb'

class TestParsePlayersFromGamedayXMLFiles < MiniTest::Unit::TestCase  
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
end