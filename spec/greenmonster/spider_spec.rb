require 'spec_helper'

describe Greenmonster::Spider do
  before(:all) do
    FileUtils.rm_r('spec/games/mlb')
    Greenmonster.set_games_folder('spec/games')
    @spider = Greenmonster::Spider.new
  end

  describe "#pull_days" do
    it "calls #pull_day for each date in the supplied range" do
      @spider.stubs(pull_day: nil)

      @spider.pull_days(Date.new(2012,1,1)..Date.new(2012,1,3), {arg: 123})

      @spider.should have_received(:pull_day).with(Date.new(2012,1,1), {arg: 123})
      @spider.should have_received(:pull_day).with(Date.new(2012,1,2), {arg: 123})
      @spider.should have_received(:pull_day).with(Date.new(2012,1,3), {arg: 123})
    end
  end

  describe "#pull_day" do
    before(:each) do
      @spider.stubs(
        game_links_on_gameday_date_page: ['gid_2012_03_27_aaamlb_aabmlb_1', 'gid_2012_03_27_bbbmlb_bbcmlb_1'],
        pull_game: true
      )
    end

    it "calls #game_links_on_gameday_date_page with the date and sport code" do
      @spider.pull_day(Date.new(2012,3,27), 'mlb')

      @spider.should have_received(:game_links_on_gameday_date_page).with(
        Date.new(2012,3,27),
        'mlb'
      )
    end

    it "calls #pull_game for each game link on the page" do
      @spider.pull_day(Date.new(2012,3,27), 'mlb')

      @spider.should have_received(:pull_game).with(
        'gid_2012_03_27_aaamlb_aabmlb_1',
        Date.new(2012,3,27)
      )

      @spider.should have_received(:pull_game).with(
        'gid_2012_03_27_bbbmlb_bbcmlb_1',
        Date.new(2012,3,27)
      )
    end
  end

  describe "#pull_game" do
    context "when all files are present on mlb.com server" do
      before(:all) do
        @spider.pull_game('gid_2012_09_10_atlmlb_milmlb_1', Date.new(2012,9,10))
        @local_path = Pathname.new(
          './spec/games/mlb/year_2012/month_09/day_10/gid_2012_09_10_atlmlb_milmlb_1'
        )
      end

      it "downloads boxscore.xml for the game" do
        (@local_path + 'boxscore.xml').exist?.should be_true
      end

      it "downloads game_events.xml for the game" do
        (@local_path + 'game_events.xml').exist?.should be_true
      end

      it "downloads linescore.xml for the game" do
        (@local_path + 'linescore.xml').exist?.should be_true
      end

      it "downloads players.xml for the game" do
        (@local_path + 'players.xml').exist?.should be_true
      end

      it "downloads the inning files for the games in 2007 or later" do
        (@local_path + 'inning' + 'inning_all.xml').exist?.should be_true
      end
    end
  end

end