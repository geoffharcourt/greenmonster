#encoding: utf-8

require "date"
require "fileutils"
require "httparty"
require "nokogiri"
require "greenmonster/version"
require "greenmonster/file_downloader"
require "greenmonster/innings_downloader"
require "greenmonster/game_spider"
require "greenmonster/day_spider"

module Greenmonster
  REMOTE_DATA_ROOT = "http://gd2.mlb.com/components/game"

  def self.local_data_location
    raise NoLocalDataLocationSet unless @@local_data_location

    @@local_data_location
  end

  def self.set_local_data_location(folder)
    @@local_data_location = folder
  end

  class NoLocalDataLocationSet < Exception; end
end
