require './test/test_helper.rb'

class GreenmonsterSpiderTest < MiniTest::Unit::TestCase
  def setup
    @local_test_data_location = "./greenmonster_test_games"
    FileUtils.mkdir_p @local_test_data_location
  end
  
  def test_format_date_as_folder
    assert_equal "year_2011/month_07/day_04", Greenmonster::Spider.format_date_as_folder(Date.new(2011,7,4))
    assert_equal "year_2012/month_12/day_31", Greenmonster::Spider.format_date_as_folder(Date.new(2012,12,31))
  end
  
  def test_copy_gameday_xml
    paths = {
      :localGameFolder => "#{@local_test_data_location}/mlb/year_2011/month_05/day_03/gid_2011_05_03_sfnmlb_nynmlb_1/",
      :mlbGameFolder => "http://gd2.mlb.com/components/game/mlb/year_2011/month_05/day_03/gid_2011_05_03_sfnmlb_nynmlb_1/"
    }
    FileUtils.mkdir_p paths[:localGameFolder] + 'inning'
    
    %w(linescore.xml inning_all.xml).each do |f|
      Greenmonster::Spider.copy_gameday_xml(f,paths)
    end
    
    assert_equal 287337, Nokogiri::XML(open(paths[:localGameFolder] + 'linescore.xml')).search("game").first.attribute('game_pk').value.to_i
    assert_equal 10, Nokogiri::XML(open(paths[:localGameFolder] + 'inning/inning_all.xml')).search("inning").count
    assert_equal 400023, Nokogiri::XML(open(paths[:localGameFolder] + 'inning/inning_all.xml')).search("atbat").first.attribute('batter').value.to_i
  end
  
  def test_copy_gameday_xml_downloads_file_when_it_has_bad_encoding
    paths = {
      :localGameFolder => "#{@local_test_data_location}/mlb/year_2012/month_04/day_10/gid_2012_04_10_arimlb_sdnmlb_1/",
      :mlbGameFolder => "http://gd2.mlb.com/components/game/mlb/year_2012/month_04/day_10/gid_2012_04_10_arimlb_sdnmlb_1/"
    }
    FileUtils.mkdir_p paths[:localGameFolder] + 'inning'

    Greenmonster::Spider.copy_gameday_xml('inning_all.xml',paths)
    
    assert_equal 11, Nokogiri::XML(open(paths[:localGameFolder] + '/inning/inning_all.xml')).search("inning").count
  end
  
  def test_pull_day
    Greenmonster::Spider.pull_day({:print_games => false, :games_folder => @local_test_data_location, :date => Date.new(2011,6,7)})
    
    assert_equal 17, Dir.entries(@local_test_data_location + '/mlb/year_2011/month_06/day_07/').count
    
    game_location = @local_test_data_location + '/mlb/year_2011/month_06/day_07/gid_2011_06_07_bosmlb_nyamlb_1'
    %w(linescore.xml boxscore.xml players.xml eventLog.xml inning).each do |f|
      assert Dir.entries(game_location).include? f
    end
    
    boxscore = Nokogiri::XML(open(game_location + '/boxscore.xml'))
    eventlog = Nokogiri::XML(open(game_location + '/eventLog.xml'))
    players = Nokogiri::XML(open(game_location + '/players.xml'))
    innings = Nokogiri::XML(open(game_location + '/inning/inning_all.xml'))
    
    assert_equal 8, boxscore.search('pitcher').count
    assert_equal 147, boxscore.search('boxscore').first.attribute('home_id').value.to_i
    assert eventlog.search("event[number='19']").attribute('description').value.include?('Pedroia walks.')
    assert_equal 'Magadan', players.search("team[type='away']").search("coach[position='batting_coach']").attribute('last').value
    assert_equal 'Strikeout', innings.search('atbat').last.attribute('event').value
  end
  
  def test_pull_non_mlb_sport_code_games
    Greenmonster::Spider.pull_day({:sport_code => 'asx', :print_games => false, :games_folder => @local_test_data_location, :date => Date.new(2011,9,12)})
    
    assert_equal 4, Dir.entries(@local_test_data_location + '/asx/year_2011/month_09/day_12/').count
    %w(linescore.xml boxscore.xml players.xml eventLog.xml inning).each do |f|
      assert Dir.entries(@local_test_data_location + '/asx/year_2011/month_09/day_12/gid_2011_09_12_staasx_aubasx_1/').include? f
    end
  end
  
  def test_pull_games_prior_to_2008
    Greenmonster::Spider.pull_game('gid_2007_04_15_detmlb_tormlb_1', {:games_folder => @local_test_data_location, :print_games => false})
    assert_equal 12, Dir.entries(@local_test_data_location + '/mlb/year_2007/month_04/day_15/gid_2007_04_15_detmlb_tormlb_1/inning/').count
  end
  
  def test_pull_all_sport_codes_for_day
    Greenmonster::Spider.pull_day({:all_sport_codes => true, :print_games => false, :games_folder => @local_test_data_location, :date => Date.new(2011,9,13)})
    assert_equal 8, Dir.entries(@local_test_data_location).count
  end
  
  def test_pull_days
    Greenmonster::Spider.pull_days((Date.new(2011,10,9)..Date.new(2011,10,10)), {:print_games => false, :games_folder => @local_test_data_location})
    assert_equal 4, Dir.entries(@local_test_data_location + '/mlb/year_2011/month_10/').count
    assert_equal 6, Dir.entries(@local_test_data_location + '/mlb/year_2011/month_10/day_09').count
  end
  
  def test_pull_day_with_default_folder_location
    Greenmonster.set_games_folder @local_test_data_location
    Greenmonster::Spider.pull_day({:date => Date.new(2011,7,4), :print_games => false})
    assert_equal 288186, Nokogiri::XML(open(@local_test_data_location + '/mlb/year_2011/month_07/day_04/gid_2011_07_04_tormlb_bosmlb_1/boxscore.xml')).search('boxscore').first.attribute('game_pk').value.to_i
  end
  
  def test_pull_single_game_by_game_id
    Greenmonster::Spider.pull_game('gid_2011_07_04_tormlb_bosmlb_1', {:games_folder => @local_test_data_location, :print_games => false})
  end
  
  def test_no_exception_raised_if_game_data_not_available
    assert_output(nil,'') do
      Greenmonster::Spider.pull_game('gid_2011_07_04_zzzmlb_yyymlb_1', {:games_folder => @local_test_data_location, :print_games => false})
    end
  end
  
  def test_local_file_not_created_if_remote_file_does_not_exist
    Greenmonster::Spider.pull_game('gid_2011_07_01_xxxmlb_yyymlb_1', {:games_folder => @local_test_data_location, :print_games => false})
    assert_equal 3, Dir.entries(@local_test_data_location + '/mlb/year_2011/month_07/day_01/gid_2011_07_01_xxxmlb_yyymlb_1').count
  end
  
  def test_sport_code_argument_as_array
    Greenmonster::Spider.pull_day({:date => Date.new(2011,9,16), :sport_code => ['mlb','rok'], :print_games => false, :games_folder => @local_test_data_location})
    assert_equal 4, Dir.entries(@local_test_data_location).count
  end
  
  def teardown
    FileUtils.remove_dir @local_test_data_location
    Greenmonster.set_games_folder('./test/games')
  end
end