require './test/test_helper.rb'

class TestCreateMlbGameFromGamedayXMLGame < MiniTest::Unit::TestCase
  def test_create_game_data_from_gameday_xml_game
    GamedayGame.create_from_gameday_xml_game('gid_2011_07_04_tormlb_bosmlb_1')
    assert_equal 1, GamedayGame.all.count
  end

  def test_fail_gracefully_if_game_does_not_have_data
    refute GamedayGame.create_from_gameday_xml_game('gid_2011_07_04_tormlb_bosmlb_8')
  end
end