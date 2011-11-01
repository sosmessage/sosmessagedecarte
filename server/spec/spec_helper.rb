require 'rubygems'
require 'sinatra'
require 'json'
require 'rack'
require 'rack/test'

require File.join(File.dirname(__FILE__), '..', 'server_v1')

# set test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false
