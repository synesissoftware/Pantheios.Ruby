#!/usr/bin/env ruby

#############################################################################
# File:         test/scratch/log_rolling_by_period_daily.rb
#
# Purpose:      Tests the log-rolling functionality of SimpleFileLogService
#
# Created:      4th February 2018
# Updated:      4th February 2018
#
# Author:       Matthew Wilson
#
# Copyright:    <<TBD>>
#
#############################################################################

$:.unshift File.join(File.dirname(__FILE__), *(['..'] * 2), 'lib')

require 'pantheios/globals'
require 'pantheios/services/simple_file_log_service'

log_path_base = File.join(File.dirname(__FILE__), 'log_files', 'log_rolling_by_period_daily')

Pantheios::Globals.INITIAL_SERVICE_INSTANCES = Pantheios::Services::SimpleFileLogService.new log_path_base, roll_period: :daily

require 'pantheios'

include Pantheios

log :notice, 'program starting ...'

log(:notice) { 'program started' }

(0..1000).each do |n|

	log :informational, "increment #{n}: '#{'*' * 10 * n}'"

	sleep 100
end

at_exit { log :notice, 'program ending ...' }


