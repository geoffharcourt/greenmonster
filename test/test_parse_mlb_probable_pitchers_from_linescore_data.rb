require './test/test_helper.rb'

class ParseMlbProbablePitchersFromLinescoreDataTest < MiniTest::Unit::TestCase
   def test_create_probable_pitcher
     node = nil

     a = ProbablePitcher.create_from_gameday_xml(node)

     assert_equal ProbablePitcher, a.class
     assert_equal 000000, a.player_id
     assert_equal 'a', a.side
     assert_equal 111111, a.game_pk
   end
end
