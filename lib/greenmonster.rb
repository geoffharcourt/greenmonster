require "rubygems"
require "bundler/setup"

require 'httparty'
require 'nokogiri'
require 'pathname'
require 'fileutils'
require 'active_record'
require 'date'

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
    @@games_folder = Pathname.new(location)
  end

  ##
  # Return the default games folder location
  #
  # Example:
  #   >> Greenmonster.set_games_folder("/Users/geoff/game_data")
  #   >> Greenmonster.games_folder
  #   => #<Pathname:/Users/geoff/game_data> 

  def self.games_folder
    @@games_folder
  end
  
  def self.format_date_as_folder(date)
    date.strftime("year_%Y/month_%m/day_%d")
  end
  
  ##
  # Walk the dates in a range of dates, and execute whatever
  # methods on the date and argument set specified. Used when 
  # processing games and players.
  #
  #
  
  def self.traverse_dates(range = (Date.today..Date.today), args = {})
     range.each do |day|
        yield day,args
     end
  end
  
  ##
  # Walk the game folders in a range of dates, and execute whatever
  # methods on the game folder and argument set specified. Used when 
  # processing games and players.
  #
  #
  
  def self.traverse_folders_for_date(day,args = {})
     begin
        folders = Dir.entries(Pathname.new(args[:games_folder] || @@games_folder) + (args[:sport_code] || 'mlb') + self.format_date_as_folder(day))
     rescue StandardError => boom
        puts "No files for #{day.to_s}."
     end

     unless folders.nil?
        folders.sort.each do |gdir|
           if gdir[0,3] == 'gid' and gdir[-4,4] != "_bak"
              yield gdir, args
           end
        end
     end
  end
end

require 'greenmonster/spider'
require 'greenmonster/model_extensions/player'
require 'greenmonster/model_extensions/mlb_game'
require 'greenmonster/parser'
