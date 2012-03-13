require 'httparty'
require 'nokogiri'
require 'fileutils'

module Greenmonster
  @@games_folder = nil
  
  ##
  # Set the default folder to which games
  # are saved after being downloaded from
  # the server.
  #
  # Example: 
  #   => Greenmonster.set_games_folder("/Users/geoff/game_data")
  #
  # Arguments:
  #   location: (String)
  #
  
  def self.set_games_folder(location)
    @@games_folder = location
  end

  ##
  # Return the default games folder location
  #
  # Example:
  #   >> Greenmonster.set_games_folder("/Users/geoff/game_data")
  #   >> Greenmonster.games_folder
  #   => "/Users/geoff/game_data" 

  def self.games_folder
    @@games_folder
  end
end

require 'greenmonster/spider'