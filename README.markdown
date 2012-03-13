Greenmonster
============

Greenmonster is a toolkit for baseball stat enthusiasts or sabermetricians to build a database of play-by-play stats from MLB's [Gameday XML data](http://gd.mlb.com/components/game/).

The gem currently spiders games from MLB's servers. Over the season, I will be extracting pieces out of my toolkit to parse Gameday XML data to produce play-by-play database of MLB and MiLB stats.

Usage 
-----

If you don't want to specify a download location every time you run the spider, you can set a default games folder location using Greenmonster.set_games_location:

	# Set games folder location
	>> Greenmonster.set_games_folder('/Users/geoff/games/')

The spider utility has three public class methods: Spider.pull_game, Spider.pull_day, and Spider.pull_days. 

Spider.pull_game takes a game_id (the folder name of the game on the Gameday server) and a hash of options as arguments. If for some reason the game does not fall in the expected folder for the game's date or sport code, you can add those options to the arguments hash. Other options include :games_folder and :print_games (if false, game IDs are not printed to screen).

    # Pulls MLB's 7/4/2011 Toronto @ Boston game
	>> Greenmonster::Spider.pull_game('gid_2011_07_04_tormlb_bosmlb_1', {:print_games => false})

Spider.pull_day takes an hash of options as an argument. Greenmonster will create subfolders by MLB "sport_code" (MLB games fall under 'mlb', various minor league games and non-MLB/MiLB games fall under other sport code designations), and then children folders for years, months, days, and specific games.

    # Pulls all MLB games for today
    >> Greenmonster::Spider.pull_day({:date => Date.today, :games_folder => './home/geoff/games'})

    # Pulls all rookie league games for today
    >> Greenmonster::Spider.pull_day({:sport_code => 'rok', :date => Date.today, :games_folder => './home/geoff/games'})


Spider.pull_days takes a range of dates to process as an argument, plus a hash of arguments to pass to Spider.pull.

    # Pulls all MLB games for in April, 2012
	>> Greenmonster::Spider.pull_days((Date.new(2012,4,1)..Date.new(2012,4,30)), {:games_folder => './home/geoff/games'})
	

Requirements
------------
- Ruby 1.9
- Nokogiri
- HTTParty

Testing
-------

The test suite downloads a few days of data, so it is not fast to execute.


License
-------
(The MIT License)

Copyright &copy; [Geoff Harcourt](http://github.com/geoffharcourt) 2012

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ‘Software’), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED ‘AS IS’, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.