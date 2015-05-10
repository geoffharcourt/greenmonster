module GreenmonsterPathHelpers
  def remove_games_directory
    FileUtils.rm_rf(games_path)
  end

  def games_path
    @games_path ||= Pathname.new("#{tmp_path}/games")
  end

  def create_tmp_directory
    FileUtils.mkdir_p(tmp_path)
  end

  def tmp_path
    @tmp_path ||= Pathname.new("#{root_path}/tmp")
  end

  def root_path
    File.expand_path("../../../", __FILE__)
  end
end
