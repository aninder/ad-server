require 'sinatra'
require 'adserver'


set :environment, :development
set :run, false

run Sinatra::Application
