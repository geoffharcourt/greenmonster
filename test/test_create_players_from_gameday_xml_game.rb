require './test/test_helper.rb'

class Athlete < SuperModel::Base
  attr_accessor :first, :last
  include Greenmonster::Player
  
  def self.find_or_initialize_by_id(id_number)
    begin
      a = self.find(id_number)
    rescue
    end
    
    if a.nil?
      return self.find_or_create_by_id(id_number)
    else
      return a
    end
  end
end

class TestCreatePlayersFromGamedayXMLGame < MiniTest::Unit::TestCase
  def test_create_players_from_gameday_xml_game
    Athlete.create_from_gameday_xml_game('gid_2011_07_04_tormlb_bosmlb_1')
    assert_equal 50, Athlete.all.count
  end
  
  def setup
    Greenmonster.set_games_folder('./test/games')
  end
end