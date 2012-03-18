require 'minitest/autorun'
require 'greenmonster'

Athlete = Class.new do 
  attr_accessor :first, :last
  include Greenmonster::Player
end

class GreenmonsterPlayerTest < MiniTest::Unit::TestCase
  def test_to_s
    a = Athlete.new
    a.first = "Roy"
    a.last = "Hobbs"
    
    assert_equal "Roy Hobbs", a.to_s
  end
end
