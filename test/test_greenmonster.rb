require './test/test_helper.rb'

class GreenmonsterTest < MiniTest::Unit::TestCase
  def setup
  end
  
  def test_set_games_folder_location
    Greenmonster.set_games_folder('./test_greenmonster_folder')
    assert_equal './test_greenmonster_folder', Greenmonster.games_folder.to_s
  end
  
  def teardown
  end
end
