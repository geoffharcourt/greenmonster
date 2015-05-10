require "spec_helper"

describe Greenmonster::FileDownloader do
  describe "#pull" do
    it "downloads and saves the requested file to the specified folder" do
      VCR.use_cassette "gid_2015_04_18_balmlb_bos_mlb_1/players.xml" do
        FileUtils.mkdir_p(
          games_path +
            "mlb/year_2015/month_04/day_18" +
            "gid_2015_04_18_balmlb_bosmlb_1"
        )

        described_class.new(
          game_path: "mlb/year_2015/month_04/day_18/gid_2015_04_18_balmlb_bosmlb_1",
          file_name: "players.xml"
        ).pull

        expect(
          File.read(
            games_path +
              "mlb/year_2015/month_04/day_18" +
              "gid_2015_04_18_balmlb_bosmlb_1/players.xml"
          )
        ).to eq(File.read("/Users/geoff/github/geoffharcourt/greenmonster/spec/fixtures/players.xml"))
      end
    end

    it "does not save the file on a non-200 server response" do
      VCR.use_cassette "gid_2015_04_18_balmlb_bos_mlb_2/players.xml" do
        FileUtils.mkdir_p(
          games_path +
            "mlb/year_2015/month_04/day_18" +
            "gid_2015_04_18_balmlb_bosmlb_2"
        )

        described_class.new(
          game_path: "mlb/year_2015/month_04/day_18/gid_2015_04_18_balmlb_bosmlb_2",
          file_name: "players.xml"
        ).pull

        expect(
          File.exist?(
            games_path +
              "mlb/year_2015/month_04/day_18" +
              "gid_2015_04_18_balmlb_bosmlb_2/players.xml"
          )
        ).to be_falsy
      end
    end
  end
end
