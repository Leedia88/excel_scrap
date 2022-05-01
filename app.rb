require 'bundler'
Bundler.require

$:.unshift File.expand_path("./../lib", __FILE__)
require 'app/scrapper'
require 'views/done'


#Scrapper.new.save_as_JSON
Scrapper.new.save_as_spreadsheet
#Scrapper.new.save_as_csv

