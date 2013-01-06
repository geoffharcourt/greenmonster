Greenmonster
============

Greenmonster is a toolkit for baseball stat enthusiasts or sabermetricians to build a database of play-by-play stats from MLB's [Gameday XML data](http://gd.mlb.com/components/game/). The current tool provides the ability to spider Gameday XML data from MLB's servers for personal research. Future iterations of the tool will provide the ability to parse the data and store it in a SQL database.

Usage
=====

Spider
------

If you don't want to specify a download location every time you run the spider, you can set a default games folder location using Greenmonster.set_games_location:

```ruby
# Set games folder location
Greenmonster.set_games_folder('/Users/geoff/games/')
```

The spider utility has three public class methods: Spider.pull_game, Spider.pull_day, and Spider.pull_days.

Spider.pull_game takes a game_id (the folder name of the game on the Gameday server) and the date. The date is necessary because if a game is postponed or (yes, it's happened this decade) preponed, the game ID might have a date different than the actual date on which the game was played.

```ruby
# Pull MLB's 7/4/2011 Toronto @ Boston game
Greenmonster::Spider.pull_game('gid_2011_07_04_tormlb_bosmlb_1', Date.new(2011,7,4))
```

Spider.pull_day takes an hash of options as an argument. Greenmonster will create subfolders by MLB "sport_code" (MLB games fall under 'mlb', various minor league games and non-MLB/MiLB games fall under other sport code designations), and then children folders for years, months, days, and specific games. Sport code can be a string or an array of sport code strings.

```ruby
# Pull all MLB games for today
Greenmonster::Spider.pull_day(Date.today, 'mlb')

# Pull all rookie league games for today
Greenmonster::Spider.pull_day(Date.today, 'rok')

# Pull all games in all sport codes for today
Greenmonster::SPORT_CODES.each do |sport_code|
  Greenmonster::Spider.pull_day(Date.today, sport_code)
end
```



Spider.pull_days takes a range of dates to process as an argument, plus the sport code for the games (MLB.

```ruby
# Pull all MLB games for in April, 2012
Greenmonster::Spider.pull_days((Date.new(2012,4,1)..Date.new(2012,4,30)), 'mlb')
```	



Requirements
------------
- Ruby 1.9
- Bundler
- Nokogiri
- HTTParty

Testing
-------

The test suite is being migrated to RSpec, and uses bourne.


License
-------
(The MIT License)

Copyright &copy; [Geoff Harcourt](http://github.com/geoffharcourt) 2012-2013

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ‘Software’), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED ‘AS IS’, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
