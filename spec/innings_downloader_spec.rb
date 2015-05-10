require "spec_helper"

describe Greenmonster::InningsDownloader do
  let(:downloader) { spy("FileDownloader") }

  before do
    allow(Greenmonster::FileDownloader).to receive(:new) { downloader }
  end

  describe "#pull" do
    it "invokes a FileDownloader for each inning in the game" do
      VCR.use_cassette "gid_2007_10_01_sdnmlb_colmlb_1/innings" do
        described_class.new(
          game_path:
            "mlb/year_2007/month_10/day_01/gid_2007_10_01_sdnmlb_colmlb_1"
        ).pull

        (1..13).each do |inning|
          expect(Greenmonster::FileDownloader).to have_received(:new).with(
            game_path:
              "mlb/year_2007/month_10/day_01/gid_2007_10_01_sdnmlb_colmlb_1",
            file_name: "inning/inning_#{inning}.xml"
          )
        end
        expect(downloader).to have_received(:pull).exactly(13).times
      end
    end

    it "does not attempt to download innings that don't exist" do
      VCR.use_cassette "gid_2007_10_01_sdnmlb_colmlb_1/innings" do
        described_class.new(
          game_path:
            "mlb/year_2007/month_10/day_01/gid_2007_10_01_sdnmlb_colmlb_1"
        ).pull

        expect(Greenmonster::FileDownloader).not_to have_received(:new).with(
          game_path:
            "mlb/year_2007/month_10/day_01/gid_2007_10_01_sdnmlb_colmlb_1",
          file_name: "inning/inning_14.xml"
        )
      end
    end
  end
end
