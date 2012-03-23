require './test/test_helper.rb'

class GreenmonsterTraversalTest < MiniTest::Unit::TestCase
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
    assert_block do
      Greenmonster.traverse_folders_for_date(Date.new(2012,3,27), {:true_test => true, :false_test => false}) do |g,a|
        g == 'gid_2012_03_27_aaamlb_aabmlb_1' and a == {:true_test => true, :false_test => false}
      end
    end
  end
  
  def test_traverse_folders_for_non_mlb_sport_code    
    assert_block do
      Greenmonster.traverse_folders_for_date(Date.new(2012,3,27), {:sport_code => 'tst'}) do |g,a|
        g == 'gid_2012_03_27_aaatst_aabtst_1'
      end
    end
  end
end