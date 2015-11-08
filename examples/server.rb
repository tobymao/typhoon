#!/usr/bin/env ruby

require_relative '../lib/typhoon.rb'

Typhoon::Server.new("localhost", 8080).run
