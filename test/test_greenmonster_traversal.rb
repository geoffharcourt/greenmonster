require 'minitest/autorun'
require 'greenmonster'

class GreenmonsterTraversalTest < MiniTest::Unit::TestCase
  def setup
    Greenmonster.set_games_folder "./greenmonster_test_games"
    FileUtils.mkdir_p Greenmonster.games_folder
  end
  
  def test_traverse_dates_across_range
    assert_equal (Date.new(2012,4,15)..Date.new(2012,4,30)), Greenmonster.traverse_dates(Date.new(2012,4,15)..Date.new(2012,4,30)) {|g,a| g}
  end
  
  def test_traverse_dates_with_no_range
    assert_block do 
      Greenmonster.traverse_dates do |d,a|
        d == Date.today
      end 
    end
  end
  
  def test_traverse_folders_for_date
    FileUtils.mkdir_p Greenmonster.games_folder + 'mlb' + 'year_2012' + 'month_03' + 'day_27' + 'gid_2012_03_27_aaamlb_aabmlb_1'
    
    assert_block do
      Greenmonster.traverse_folders_for_date(Date.new(2012,3,27), {:true_test => true, :false_test => false}) do |g,a|
        g == 'gid_2012_03_27_aaamlb_aabmlb_1' and a == {:true_test => true, :false_test => false}
      end
    end
  end
  
  def test_traverse_folders_for_non_mlb_sport_code
    FileUtils.mkdir_p Greenmonster.games_folder + 'tst' + 'year_2012' + 'month_03' + 'day_27' + 'gid_2012_03_27_aaatst_aabtst_1'
    
    assert_block do
      Greenmonster.traverse_folders_for_date(Date.new(2012,3,27), {:sport_code => 'tst'}) do |g,a|
        g == 'gid_2012_03_27_aaatst_aabtst_1'
      end
    end
  end
  
  def teardown
    FileUtils.remove_dir Greenmonster.games_folder
  end
end
