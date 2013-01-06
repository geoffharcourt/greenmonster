# The Gameday XML Spider utility
class Greenmonster::Spider
  include HTTParty

  ##
  # Pull Gameday XML files for a given game, specified by the game
  # ID. If date and sport code are not specified as options, these
  # values are guessed from the game ID string using the home team's
  # sport code and the date from the scheduled date values in the game
  # ID.
  #
  # Example:
  #  >> Gameday::Spider.pull_game('',{:games_folder => })

  def pull_game(game_id, date)
    make_folders_for_game(game_id, date)

    %w(boxscore.xml game_events.xml inning_all.xml linescore.xml players.xml).each do |file_name|
      copy_gameday_xml(game_id, date, file_name)
    end
  end

  ##
  # Pull Gameday XML files for a given date. Default options for
  # the spider are to pull games with sport_code of 'mlb' (games
  # played by MLB games rather than MiLB teams or foreign teams)
  # and to pull games on the current date.
  #
  # Example:
  #  # Pull games from July 4, 2011
  #  >> Gameday::Spider.pull_day({:date => Date.new(2011,7,1), :games_folder => '/Users/geoff/games'})
  #
  # Arguments:
  #  args: (Hash)
  #

  def pull_day(date, sport_code)
    game_links_on_gameday_date_page(date, sport_code).each do |game_id|
      pull_game(game_id, date)
    end
  end

  ##
  # Pull Gameday XML files for a range of dates. The args hash
  # passes arguments like games_folder location on to Spider.pull.
  #
  # Example:
  #  # Pull all games in MLB in July 2011
  #  >> Gameday::Spider.pull_days(Date.new(2011,7,1)..Date.new(2011,7,31), {:games_folder => '/Users/geoff/games'})
  #
  # Arguments:
  #  range: (Range)
  #  args: (Hash)

  def pull_days(range, sport_code)
    range.each { |date| self.pull_day(date, sport_code) }
  end


  private

  def get_gameday_date_page(date, sport_code)
    self.class.get(gameday_date_and_sport_code_url(date, sport_code))
  end

  def links_on_gameday_date_page(date, sport_code)
    Nokogiri::XML(get_gameday_date_page(date, sport_code)).search('a').map do |a|
      a.attribute('href').value
    end
  end

  def game_links_on_gameday_date_page(date, sport_code)
    links_on_gameday_date_page(date, sport_code).select do |link|
      link[0,4] == "gid_" && link[-5,4] != "_bak"
    end
  end

  def gameday_url_root
    "http://gd2.mlb.com/components/game/"
  end

  def gameday_date_and_sport_code_url(date, sport_code)
    "#{gameday_url_root}#{sport_code}/#{format_date_as_folder(date)}"
  end

  def gameday_game_url(game_id, date)
    gameday_url_root + remote_game_path(game_id, date)
  end

  def remote_game_path(game_id, date)
    "#{home_sport_code_from_game_id(game_id)}/#{format_date_as_folder(date)}/#{game_id}"
  end

  def home_sport_code_from_game_id(game_id)
    game_id[-5,3]
  end

  def inning_prefix(file_name)
    if file_name =~ /inning/
      'inning/'
    else
      ''
    end
  end

  def remote_file_url(game_id, date, file_name)
    gameday_game_url(game_id, date) + '/' + inning_prefix(file_name) + '/' + file_name
  end

  def download_gameday_xml(game_id, date, file_name)
    self.class.get(remote_file_url(game_id, date, file_name)).body.force_encoding("ISO-8859-1").encode("UTF-8")
  end

  def local_game_path(game_id, date)
    Pathname.new(
      Greenmonster.games_folder +
      home_sport_code_from_game_id(game_id) +
      format_date_as_folder(date) +
      game_id
    )
  end

  def copy_gameday_xml(game_id, date, file_name)
    download = download_gameday_xml(game_id, date, file_name)

    unless download.include?('404 Not Found')
      open(local_game_path(game_id, date) + inning_prefix(file_name) + file_name, 'w') do |file|
        file.write(download)
      end
    end
  end

  def format_date_as_folder(date)
    Greenmonster.format_date_as_folder(date)
  end

  def make_folders_for_game(game_id, date)
    FileUtils.mkdir_p(local_game_path(game_id, date) + 'inning')
  end
end