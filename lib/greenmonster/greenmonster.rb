require 'httparty'
require 'nokogiri'

module Greenmonster
  class Spider
    include HTTParty
  
    def self.copyGameDayXML (file_name,location,paths)
      open(paths[:localGameFolder] + "#{file_name =~ /inning/ ? 'inning/' : ''}" + file_name, 'w') do |file|
        file.write(self.get(paths[:mlbGameFolder] + "#{file_name =~ /inning/ ? 'inning/' : ''}" + file_name).body)
      end
    end

    def self.format_date_as_folder(date)
      date.strftime("year_%Y/month_%m/day_%d")
    end
  
    def self.pull(date = Date.today,args = {})
      game_day_url_for_date = "http://gd2.mlb.com/components/game/#{args[:league] || 'mlb'}/#{format_date_as_folder(date)}"
      puts "Finding games in #{game_day_url_for_date}"
  
      # Iterate through every hyperlink on the page.
      # These links represent the individual game folders
      # for each date.
      (Nokogiri::XML(self.get(game_day_url_for_date))/"a").each do |e|
  
        # See if the link is to a game, otherwise ignore it
        if e.attribute('href').value[0,3]  == "gid"
          puts e.attribute('href').value.gsub('/','')
        
          paths = {
            :localGameFolder => "#{MlbGame::GAMES_LOCATION}/#{args[:league] || 'mlb'}/#{format_date_as_folder(date)}/#{e.attribute('href').value}",
            :mlbGameFolder => "#{game_day_url_for_date}/#{e.attribute('href').value}"
          }
          
          FileUtils.mkdir_p paths[:localGameFolder] + 'inning'

          begin
            copyGameDayXML('linescore.xml','base',paths)
          
            if date.year > 2007
              copyGameDayXML('inning_all.xml','inning',paths)
              copyGameDayXML('inning_hit.xml','inning',paths)
            else
              # Iterate through the inning files, but skip inning 
              # files numbered 0 (some bad spring training data)
              (Nokogiri::XML(self.get("#{paths[:mlbGameFolder]}/inning/").body).search('a')).each do |ic|
                copyGameDayXML(ic.attribute('href'),'inning',paths) if ic.attribute('href').value[-3,3]  == "xml" unless ic.attribute('href').value[-6,6] == "_0.xml"
              end
            end

            # Copy base data files 
            # (if inning data wasn't there, this gets skipped)
            ['boxscore.xml','eventLog.xml','players.xml'].each do |file|
              copyGameDayXML(file,'base',paths)
            end
          rescue OpenURI::HTTPError => bang  
          end
        end
      end
    end

    def self.pull_days(range = [Date.today],args = {})
      range.each {|day| self.pull(day,args)}
    end
  end
end