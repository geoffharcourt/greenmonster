# The Gameday XML Spider utility
class Greenmonster::Spider
  include HTTParty
    
  ##
  # Pull Gameday XML files for a given date. Default options for 
  # the spider are to pull games with sport_code of 'mlb' (games 
  # played by MLB games rather than MiLB teams or foreign teams) 
  # and to pull games on the current date. You must specify a 
  # :games_folder argument that is the root folder under  which 
  # all games will be placed.
  #
  # Example:
  #   # Pull games from July 4, 2011
  #   >> Gameday::Spider.pull({:date => Date.new(2011,7,1), :games_location => '/Users/geoff/games'})
  #
  # Arguments:
  #   args: (Hash)
  #
    
  def self.pull_day(args = {})
    args = {
      :date => Date.today,
      :league => 'mlb',
      :print_games => true,
      :games_folder => Greenmonster.games_folder
    }.merge(args)
      
    raise "Games folder location required." if args[:games_folder].nil?
      
    game_day_url_for_date = "http://gd2.mlb.com/components/game/#{args[:league]}/#{format_date_as_folder(args[:date])}"
  
    # Iterate through every hyperlink on the page.
    # These links represent the individual game folders
    # for each date. Reject any links that aren't to game
    # folders or that are to what look like backup game
    # folders.
    (Nokogiri::XML(self.get(game_day_url_for_date))/"a").reject{|l| l.attribute('href').value[0,4] != "gid_" or l.attribute('href').value[-5,4] == "_bak"}.each do |e|
      puts e.attribute('href').value.gsub('/','') if args[:print_games]
        
      paths = {
        :localGameFolder => "#{args[:games_folder]}/#{args[:league]}/#{format_date_as_folder(args[:date])}/#{e.attribute('href').value}",
        :mlbGameFolder => "#{game_day_url_for_date}/#{e.attribute('href').value}"
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
        puts "Unable to download some data for #{e.attribute('href').value}"  
      end
    end
    
    game_day_url_for_date
  end

  ##
  # Pull Gameday XML files for a range of dates. The args hash
  # passes arguments like games_folder location on to Spider.pull.
  #
  # Example:
  #   # Pull all games in MLB in July 2011
  #   >> Gameday::Spider.pull_days(Date.new(2011,7,1)..Date.new(2011,7,31), {:games_location => '/Users/geoff/games'})
  #
  # Arguments:
  #   range: (Range)
  #   args: (Hash)

  def self.pull_days(range,args = {})
    range.each {|day| self.pull_day(args.merge({:date => day}))}
  end
    
    private
    ##
    # Copy XML files from the Gameday severs to your
    # local machine for parsing and analysis. This method
    # is used by Spider.pull to put files on your local
    # machine in a similar layout to the one used by 
    # Gameday. The paths argument gets built by Spider.pull
    # during the pull process.
    #
    # Arguments: 
    #   file_name: (String)
    #   paths: (Hash)
  
    def self.copy_gameday_xml (file_name,paths)
      open(paths[:localGameFolder] + "#{file_name =~ /inning/ ? 'inning/' : ''}" + file_name, 'w') do |file|
        file.write(self.get(paths[:mlbGameFolder] + "#{file_name =~ /inning/ ? 'inning/' : ''}" + file_name).body)
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
      date.strftime("year_%Y/month_%m/day_%d")
    end
end