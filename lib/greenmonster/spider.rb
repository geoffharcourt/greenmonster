# The Gameday XML Spider utility
module Greenmonster::Spider
  include HTTParty
  
  ##
  # Pull Gameday XML files for a given game, specified by the game 
  # ID. If date and sport code are not specified as options, these
  # values are guessed from the game ID string using the home team's
  # sport code and the date from the scheduled date values in the game
  # ID.
  #
  # Example:
  #   >> Gameday::Spider.pull_game('',{:games_folder => })
  
  def self.pull_game(game_id,args = {})
    args = {
      :date => args[:date] || Date.new(game_id[4,4].to_i, game_id[9,2].to_i, game_id[12,2].to_i),
      :sport_code => args[:sport_code] || game_id[25,3],
      :print_games => true,
      :games_folder => Greenmonster.games_folder
    }.merge(args)
    raise "Games folder location required." if args[:games_folder].nil?
    
    args[:games_folder] = Pathname.new(args[:games_folder])
    
    puts game_id if args[:print_games]
        
    paths = {
      :localGameFolder => args[:games_folder] + args[:sport_code] + format_date_as_folder(args[:date]) + game_id,
      :mlbGameFolder => "#{gameday_league_and_date_url(args)}/#{game_id}/"
    }
        
    FileUtils.mkdir_p paths[:localGameFolder] + 'inning'

    begin
      # Always copy linescore first. If we can't get this
      # data, all other game data is useless.
      copy_gameday_xml('linescore.xml',paths)
      
      if args[:date].year > 2007
        copy_gameday_xml('inning_all.xml',paths)
        copy_gameday_xml('inning_hit.xml',paths)
      else
        # Iterate through the inning files, but skip inning 
        # files numbered 0 (some bad spring training data).
        # Necessary for games prior to 2008 because there is
        # no inning_all.xml file in older games.
        (Nokogiri::XML(self.get("#{paths[:mlbGameFolder]}/inning/").body).search('a')).each do |ic|
          copy_gameday_xml(ic.attribute('href').value,paths) if ic.attribute('href').value[-3,3]  == "xml" unless ic.attribute('href').value[-6,6] == "_0.xml" or ic.attribute('href').value.include?('Score')
        end
      end

      # Copy base data files 
      # (if inning data wasn't there, this gets skipped)
      ['boxscore.xml','eventLog.xml','players.xml'].each do |file|
        copy_gameday_xml(file,paths)
      end
    rescue StandardError => bang
      puts "Unable to download some data for #{game_id}"  
    end
    
    return game_id
  end
    
  ##
  # Pull Gameday XML files for a given date. Default options for 
  # the spider are to pull games with sport_code of 'mlb' (games 
  # played by MLB games rather than MiLB teams or foreign teams) 
  # and to pull games on the current date. 
  #
  # Example:
  #   # Pull games from July 4, 2011
  #   >> Gameday::Spider.pull_day({:date => Date.new(2011,7,1), :games_folder => '/Users/geoff/games'})
  #
  # Arguments:
  #   args: (Hash)
  #
    
  def self.pull_day(args = {})
    args = {
      :date => Date.today,
      :sport_code => 'mlb',
    }.merge(args)
    
    # If we want all sport codes, set up the array.
    if args[:all_sport_codes]
      args[:sport_codes] = %w(aaa aax afa afx asx bbc fps hsb ind int jml nae naf nas nat naw oly rok win)
    else
      args[:sport_codes] = [args[:sport_code] || 'mlb'].flatten
    end
    
    # Iterate through every hyperlink on the page.
    # These links represent the individual game folders
    # for each date. Reject any links that aren't to game
    # folders or that are to what look like backup game
    # folders.
    args[:sport_codes].each do |sport_code|
      args[:sport_code] = sport_code
      (Nokogiri::XML(self.get(gameday_league_and_date_url(args)))/"a").reject{|l| l.attribute('href').value[0,4] != "gid_" or l.attribute('href').value[-5,4] == "_bak"}.each do |e|      
        self.pull_game(e.attribute('href').value.gsub('/',''),args) 
      end
    end

    return args[:sport_code]
  end

  ##
  # Pull Gameday XML files for a range of dates. The args hash
  # passes arguments like games_folder location on to Spider.pull.
  #
  # Example:
  #   # Pull all games in MLB in July 2011
  #   >> Gameday::Spider.pull_days(Date.new(2011,7,1)..Date.new(2011,7,31), {:games_folder => '/Users/geoff/games'})
  #
  # Arguments:
  #   range: (Range)
  #   args: (Hash)

  def self.pull_days(range,args = {})
    range.each {|day| self.pull_day(args.merge({:date => day}))}
  end
    
    private
    ##
    # Return the Gameday URL for a given sport_code
    # and date. Argument must include :date, but
    # :sport_code will be assumed to be 'mlb' if not
    # specified.
    #
    # Arguments:
    #   args: (Hash)
    #
    def self.gameday_league_and_date_url(args = {})
      raise "Date required." unless args[:date]
      args[:sport_code] ||= 'mlb'
    
      "http://gd2.mlb.com/components/game/#{args[:sport_code]}/#{format_date_as_folder(args[:date])}"
    end
    
    ##
    # Copy XML files from the Gameday severs to your
    # local machine for parsing and analysis. This method
    # is used by Spider pull class methods to put files on 
    # your local machine in a similar layout to the one used by 
    # Gameday. The paths argument gets built by Spider.pull
    # during the pull process.
    #
    # Arguments: 
    #   file_name: (String)
    #   paths: (Hash)
  
    def self.copy_gameday_xml (file_name,paths)
      download = self.get(paths[:mlbGameFolder] + "#{file_name =~ /inning/ ? 'inning/' : ''}" + file_name).body
      unless download.include?('404 Not Found')
        open(paths[:localGameFolder] + (file_name =~ /inning/ ? 'inning/' : '') + file_name, 'w') do |file|
          file.write(download) 
        end
      end
    end
  
    ##
    # Output a folder format similar to the one used by Gameday.
    # 
    # Example:
    #   >> Spider.format_date_as_folder(Date.new(2011,7,4))
    #   => "year_2011/month_07/day_04"
    # 
    # Arguments:
    #   date: (Date)
  
    def self.format_date_as_folder(date)
      Greenmonster.format_date_as_folder(date)
    end
    
    def self.test_method
      self.super
    end
end
