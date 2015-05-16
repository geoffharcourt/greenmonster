[![Code Climate](https://codeclimate.com/github/geoffharcourt/greenmonster/badges/gpa.svg)](https://codeclimate.com/github/geoffharcourt/greenmonster)
[![Build Status](https://travis-ci.org/geoffharcourt/greenmonster.svg?branch=master)](https://travis-ci.org/geoffharcourt/greenmonster)

Greenmonster
============

Greenmonster is a toolkit for baseball stat enthusiasts or sabermetricians to retrieve play-by-play stats from MLB's [Gameday XML data](http://gd.mlb.com/components/game/). The tool provides the ability to spider Gameday XML data from MLB's servers for personal research.

Usage
=====

Spider
------

Set a location where you'll save your local games after downloading.

```ruby
# Set games folder location
Greenmonster.set_local_data_location("/Users/me/gameday")
```

Download a game from MLB.

```ruby
# Pull MLB's 7/4/2011 Toronto @ Boston game
spider = Greenmonster::GameSpider.new(game_id: "gid_2011_07_04_tormlb_bosmlb_1", sport_code: "mlb")
spider.pull
```

Download games from a given date.

```ruby
# Pull all MLB games for today
Greenmonster::DaySpider.new(date: Date.today, sport_code: "mlb").pull

# Pull all rookie league games for today
Greenmonster::DaySpider(date: Date.today, sport_code: "rok").pull
```

Requirements
------------
- Ruby 2.0
- Bundler
- Nokogiri
- HTTParty

Testing
-------

The test suite uses RSpec.


License
-------
(The MIT License)

Copyright &copy; [Geoff Harcourt](http://github.com/geoffharcourt) 2012-2015

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ‘Software’), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED ‘AS IS’, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
