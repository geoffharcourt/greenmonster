require 'spec_helper'

describe Greenmonster do

  before(:all) do
    Greenmonster.set_games_folder("spec/games")
  end

  describe ".traverse_dates" do

    it "yields each date in the range with the argument hash" do
      expect { |m|
        Greenmonster.traverse_dates((Date.new(2012)..Date.new(2012,1,3)), {test: true}, &m)
      }.to yield_successive_args(
        [Date.new(2012,1,1), {test: true}],
        [Date.new(2012,1,2), {test: true}],
        [Date.new(2012,1,3), {test: true}]
      )
    end
  end

  describe ".traverse_folders_for_date" do

    it "yields each valid game folder (gid-format, not a backup) and the argument hash" do
      expect { |m|
        Greenmonster.traverse_folders_for_date(
          Date.new(2012,3,27), {sport_code: 'tst', other_arg: 1}, &m
        )
      }.to yield_successive_args(
        ["gid_2012_03_27_aaamlb_aabmlb_1", {sport_code: "tst", other_arg: 1}],
        ["gid_2012_03_27_bbbmlb_bbcmlb_1", {sport_code: "tst", other_arg: 1}]
      )
    end

    it "does not throw an exception if no folder exists for the specified date" do
      expect {
        Greenmonster.traverse_folders_for_date(
          Date.new(1700,1,1), {sport_code: 'mlb'}
        )
      }.to_not raise_error
    end

  end

end