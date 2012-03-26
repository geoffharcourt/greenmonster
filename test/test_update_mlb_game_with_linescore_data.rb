require './test/test_helper.rb'

class TestUpdateMlbGameWithLinescore < MiniTest::Unit::TestCase
  def test_update_with_linescore_data
    g = GamedayGame.new
    g.update_with_line_score_data(Greenmonster::Parser.load_line_score('gid_2011_07_04_tormlb_bosmlb_1'))
    
    assert_equal 288186, g.game_pk
    assert_equal 111, g.home_team_id
    assert_equal 141, g.away_team_id
    assert_equal 1, g.game_num
    assert_equal '20110704tormlbbosmlb1', g.game_id
    assert_equal Date.new(2011,7,4), g.date
    assert_equal 'F', g.game_status
    assert_equal Time.new(2011,7,4,13,35), g.game_time
    assert_equal 'R', g.game_type
    assert_equal 'Fenway Park', g.game_venue
    assert_equal 3, g.venue_id
    assert_equal 'mlb', g.sport_code
    assert_equal 103, g.home_league_id
    assert_equal 103, g.away_league_id
  end
end