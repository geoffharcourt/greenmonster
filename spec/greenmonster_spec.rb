require "spec_helper"

RSpec.describe Greenmonster do
  it "has a version number" do
    expect(Greenmonster::VERSION).not_to be_nil
  end

  describe ".local_data_location" do
    it "returns the local data location" do
      Greenmonster.class_variable_set(
        :@@local_data_location,
        "/tmp/my_custom_location"
      )

      expect(Greenmonster.local_data_location).to eq("/tmp/my_custom_location")
    end

    it "raises an error if the data location isn't set" do
      Greenmonster.class_variable_set(:@@local_data_location, nil)

      expect { Greenmonster.local_data_location }.
        to raise_error(Greenmonster::NoLocalDataLocationSet)
    end
  end

  describe ".set_local_data_location" do
    it "sets the local folder for saved game data" do
      Greenmonster.set_local_data_location("/tmp/my_custom_location")

      expect(Greenmonster.local_data_location).to eq("/tmp/my_custom_location")
    end
  end
end
