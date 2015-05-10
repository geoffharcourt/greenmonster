require "spec_helper"

RSpec.describe Greenmonster::DaySpider do
  describe "#pull" do
    it "invokes a GameSpider for each game played that day within the sport code" do
      VCR.use_cassette "mlb/year_2015/month_04/day_18" do
        game_spider = spy("Greenmonster::GameSpider", pull: true)
        allow(Greenmonster::GameSpider).to receive(:new) { game_spider }

        described_class.new(sport_code: "mlb", date: Date.new(2015, 4, 18)).pull

        %w(
          gid_2015_04_18_anamlb_houmlb_1
          gid_2015_04_18_arimlb_sfnmlb_1
          gid_2015_04_18_atlmlb_tormlb_1
          gid_2015_04_18_balmlb_bosmlb_1
          gid_2015_04_18_chamlb_detmlb_1
          gid_2015_04_18_cinmlb_slnmlb_1
          gid_2015_04_18_clemlb_minmlb_1
          gid_2015_04_18_colmlb_lanmlb_1
          gid_2015_04_18_miamlb_nynmlb_1
          gid_2015_04_18_milmlb_pitmlb_1
          gid_2015_04_18_nyamlb_tbamlb_1
          gid_2015_04_18_oakmlb_kcamlb_1
          gid_2015_04_18_phimlb_wasmlb_1
          gid_2015_04_18_sdnmlb_chnmlb_1
          gid_2015_04_18_texmlb_seamlb_1
        ).each do |game_id|
          expect(Greenmonster::GameSpider).
            to have_received(:new).
            with(game_id: game_id, sport_code: "mlb")
        end
        expect(game_spider).to have_received(:pull).exactly(15).times
      end
    end

    it "correctly spiders non-MLB sport codes" do
      VCR.use_cassette "aaa/year_2015/month_05/day_09" do
        game_spider = spy("Greenmonster::GameSpider", pull: true)
        allow(Greenmonster::GameSpider).to receive(:new) { game_spider }

        described_class.new(sport_code: "aaa", date: Date.new(2015, 5, 9)).pull

        %w(
          gid_2015_05_09_albaaa_srcaaa_1
          gid_2015_05_09_bufaaa_noraaa_1
          gid_2015_05_09_cdcaaa_yucaaa_1
          gid_2015_05_09_chraaa_tolaaa_1
          gid_2015_05_09_cspaaa_iowaaa_1
          gid_2015_05_09_dubaaa_syraaa_1
          gid_2015_05_09_gwiaaa_lhvaaa_1
          gid_2015_05_09_indaaa_swbaaa_1
          gid_2015_05_09_lvgaaa_elpaaa_1
          gid_2015_05_09_mxoaaa_tijaaa_1
          gid_2015_05_09_mxoaaa_tijaaa_2
          gid_2015_05_09_nozaaa_mrbaaa_1
          gid_2015_05_09_okcaaa_omaaaa_1
          gid_2015_05_09_orhaaa_omaaaa_1
          gid_2015_05_09_pawaaa_colaaa_1
          gid_2015_05_09_pueaaa_oaxaaa_1
          gid_2015_05_09_quiaaa_camaaa_1
          gid_2015_05_09_renaaa_slcaaa_1
          gid_2015_05_09_reyaaa_mtyaaa_1
          gid_2015_05_09_rocaaa_louaaa_1
          gid_2015_05_09_rreaaa_nasaaa_1
          gid_2015_05_09_sltaaa_aguaaa_1
          gid_2015_05_09_tacaaa_freaaa_1
          gid_2015_05_09_vaqaaa_mvaaaa_1
          gid_2015_05_09_vraaaa_tabaaa_1
        ).each do |game_id|
          expect(Greenmonster::GameSpider).
            to have_received(:new).
            with(game_id: game_id, sport_code: "aaa")
        end

        expect(game_spider).to have_received(:pull).exactly(25).times
      end
    end
  end
end
