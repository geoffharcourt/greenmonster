$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "greenmonster"

Dir["./spec/support/**/*.rb"].each { |file| require file }

RSpec.configure do |config|
  config.include GreenmonsterPathHelpers

  config.before(:all) do
    create_tmp_directory
  end

  config.before(:each) do
    remove_games_directory
    Greenmonster.set_local_data_location(tmp_path)
  end
end
