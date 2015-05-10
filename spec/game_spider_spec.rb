require "spec_helper"

describe Greenmonster::GameSpider do
  let(:downloader) { spy("FileDownloader") }
  let(:dummy_downloader) { spy("Another FileDownloader") }

  before do
    allow(Greenmonster::FileDownloader).to receive(:new) { dummy_downloader }
  end

  describe "#pull" do
    it "creates the necessary folders to save data" do
      FileUtils.mkdir_p("/tmp/custom_location")
      Greenmonster.set_local_data_location("/tmp/custom_location")

      described_class.new(game_id: "gid_2015_04_18_balmlb_bosmlb_1").pull

      expect(File.exists?(File.expand_path("/tmp/custom_location/games/mlb/year_2015/month_04/day_18/gid_2015_04_18_balmlb_bosmlb_1/inning", __FILE__))).
        to be_truthy

      Greenmonster.set_local_data_location("/tmp")
    end

    it "downloads the inning_all.xml file" do
      allow(Greenmonster::FileDownloader).to receive(:new).
        with(
          game_path: "mlb/year_2015/month_04/day_18/gid_2015_04_18_balmlb_bosmlb_1",
          file_name: "inning/inning_all.xml"
        ) { downloader }

      described_class.new(game_id: "gid_2015_04_18_balmlb_bosmlb_1").pull

      expect(downloader).to have_received(:pull)
    end

    it "downloads the per-inning inning_x.xml files if inning_all.xml does not exist (pre-2008)" do
      allow(Greenmonster::InningsDownloader).to receive(:new).
        with(
          game_path:
            "mlb/year_2007/month_10/day_01/gid_2007_10_01_colmlb_sdnmlb_1",
        ) { downloader }

      described_class.new(game_id: "gid_2007_10_01_colmlb_sdnmlb_1").pull

      expect(downloader).to have_received(:pull)
    end

    it "downloads the inning_hit.xml file" do
      allow(Greenmonster::FileDownloader).to receive(:new).
        with(
          game_path:
            "mlb/year_2015/month_04/day_18/gid_2015_04_18_balmlb_bosmlb_1",
          file_name: "inning/inning_hit.xml"
        ) { downloader }

      described_class.new(game_id: "gid_2015_04_18_balmlb_bosmlb_1").pull

      expect(downloader).to have_received(:pull)
    end

    it "downloads the boxscore.xml file" do
      allow(Greenmonster::FileDownloader).to receive(:new).
        with(
          game_path:
            "mlb/year_2015/month_04/day_18/gid_2015_04_18_balmlb_bosmlb_1",
          file_name: "boxscore.xml"
        ) { downloader }

      described_class.new(game_id: "gid_2015_04_18_balmlb_bosmlb_1").pull

      expect(downloader).to have_received(:pull)
    end

    it "downloads the linescore.xml file" do
      allow(Greenmonster::FileDownloader).to receive(:new).
        with(
          game_path:
            "mlb/year_2015/month_04/day_18/gid_2015_04_18_balmlb_bosmlb_1",
          file_name: "linescore.xml"
        ) { downloader }

      described_class.new(game_id: "gid_2015_04_18_balmlb_bosmlb_1").pull

      expect(downloader).to have_received(:pull)
    end

    it "downloads the players.xml file" do
      allow(Greenmonster::FileDownloader).to receive(:new).
        with(
          game_path:
            "mlb/year_2015/month_04/day_18/gid_2015_04_18_balmlb_bosmlb_1",
          file_name: "players.xml"
        ) { downloader }

      described_class.new(game_id: "gid_2015_04_18_balmlb_bosmlb_1").pull

      expect(downloader).to have_received(:pull)
    end

    it "downloads files for sport codes outside of mlb" do
      allow(Greenmonster::FileDownloader).to receive(:new).
        with(
          game_path:
            "aaa/year_2015/month_05/day_08/gid_2015_05_08_albaaa_srcaaa_1",
          file_name: "players.xml"
        ) { downloader }

      described_class.new(
        game_id: "gid_2015_05_08_albaaa_srcaaa_1",
        sport_code: "aaa"
      ).pull

      expect(downloader).to have_received(:pull)
    end
  end
end
