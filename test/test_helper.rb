require "sqlite3"
require "supermodel"
require 'minitest/autorun'
require 'greenmonster'

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


class GamedayGame < SuperModel::Base
  include Greenmonster::MlbGame
  
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

Greenmonster.set_games_folder('./test/games')
FileUtils.mkdir_p Greenmonster.games_folder