0.4.0 / 2012-03-19
------------------
* Added Greenmonster::Player module for mixing in player-specific methods.
* Added greenmonster:install generator to install player table.
* Added Greenmonster::Parser module for parsing data out of Gameday XML files after download

0.3.1 / 2012-03-17
------------------
* Fixed sport codes as array for scenarios where not all sport codes are used.

0.3.0 / 2012-03-16
------------------
* Moved to bundler for dependency management.
* Local paths now built using Pathname rather than strings for cleaner syntax.

0.2.0 / 2012-03-14
------------------
* Added :all_sport_codes argument for Spider.pull_day to pull all known sport codes for that day.
* Better error handling and test cases for scenarios where game does not exist.
* Do not create local files if remote references return 404 errors.

0.1.0 / 2012-03-13
------------------
Spidering for everyone!