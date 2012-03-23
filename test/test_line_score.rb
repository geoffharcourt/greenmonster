require './test/test_helper.rb'

class TestLineScore < MiniTest::Unit::TestCase
  def test_load_line_score
    linescore = Greenmonster::Parser.load_line_score('gid_2011_07_04_tormlb_bosmlb_1')
    assert_equal 288186, linescore.attribute('game_pk').value.to_i
  end
  
  def test_load_line_score_returns_false_on_failure
    refute Greenmonster::Parser.load_line_score('gid_2011_07_04_tormlb_bosmlb_7')
  end
end