require "rubygems"
require "bundler/setup"

require 'httparty'
#require 'nokogiri'
#require 'pathname'
#require 'fileutils'
#require 'active_record'
require 'date'

module Greenmonster
  @@games_folder = nil

  ##
  # Set the default folder to which games
  # are saved after being downloaded from
  # the server.
  #
  # Example:
  #  => Greenmonster.set_games_folder("/Users/geoff/game_data")
  #
  # Arguments:
  #  location: (String)
  #

  def self.set_games_folder(location)
    @@games_folder = Pathname.new(location)
  end

  ##
  # Return the default games folder location
  #
  # Example:
  #  >> Greenmonster.set_games_folder("/Users/geoff/game_data")
  #  >> Greenmonster.games_folder
  #  => #<Pathname:/Users/geoff/game_data>

  def self.games_folder
    @@games_folder
  end

  ##
  # Walk the dates in a range of dates, and execute whatever
  # methods on the date and argument set specified. Used when
  # processing games and players.
  #
  #

  def self.traverse_dates(range, args)
    range.each { |day| yield day,args }
  end

  ##
  # Walk the game folders in a range of dates, and execute whatever
  # methods on the game folder and argument set specified. Used when
  # processing games and players.
  #
  #

  def self.traverse_folders_for_date(date, args)
    game_folders_for_date_and_sport_code(date, args[:sport_code]).each do |gdir|
      yield gdir, args
    end
  end


  private

  def self.game_folders_for_date_and_sport_code(date, sport_code)
    folders_for_date_and_sport_code(date, sport_code).select do |folder|
      folder[0,3] == 'gid' && folder[-4,4] != '_bak'
    end
  end

  def self.folders_for_date_and_sport_code(date, sport_code)
    begin
      Dir.entries(
        Pathname.new(games_folder) + sport_code + format_date_as_folder(date)
      ).sort
    rescue Errno::ENOENT
      []
    end
  end

  def self.format_date_as_folder(date)
    date.strftime("year_%Y/month_%m/day_%d")
  end

end

require 'greenmonster/spider'