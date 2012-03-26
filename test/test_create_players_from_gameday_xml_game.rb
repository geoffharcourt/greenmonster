require './test/test_helper.rb'

class TestCreatePlayersFromGamedayXMLGame < MiniTest::Unit::TestCase
  def test_create_players_from_gameday_xml_game
    Athlete.create_from_gameday_xml_game('gid_2011_07_04_tormlb_bosmlb_1')
    assert_equal 50, Athlete.all.count
  end
end