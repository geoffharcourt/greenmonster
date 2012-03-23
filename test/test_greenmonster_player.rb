require './test/test_helper.rb'

class Athlete < SuperModel::Base
  attr_accessor :first, :last
  include Greenmonster::Player
end

class GreenmonsterPlayerTest < MiniTest::Unit::TestCase
  def test_to_s
    assert_equal "Roy Hobbs", Athlete.new({:first => 'Roy', :last => 'Hobbs'}).to_s
  end 
end
