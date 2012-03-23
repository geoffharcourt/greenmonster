require './test/test_helper.rb'

class GamedayGame < SuperModel::Base
  include Greenmonster::MlbGame
end

class TestLineScore < MiniTest::Unit::TestCase
  def test_load_line_score
    linescore = Greenmonster::Parser.load_line_score('gid_2011_07_04_tormlb_bosmlb_1')
    assert_equal 288186, linescore.attribute('game_pk').value.to_i
  end
  
  def test_load_line_score_returns_false_on_failure
    refute Greenmonster::Parser.load_line_score('gid_2011_07_04_tormlb_bosmlb_7')
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
