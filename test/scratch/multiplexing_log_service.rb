#!/usr/bin/env ruby

#############################################################################
# File:         test/scratch/multiplexing_log_service.rb
#
# Purpose:      COMPLETE_ME
#
# Created:      7th February 2018
# Updated:      7th February 2018
#
# Author:       Matthew Wilson
#
# Copyright:    <<TBD>>
#
#############################################################################

$:.unshift File.join(File.dirname(__FILE__), *(['..'] * 2), 'lib')

require 'pantheios'
require 'pantheios/application_layer/stock_severity_levels'
require 'pantheios/services'

$num_BLS_sls	=	0
$num_ELS_sls	=	0

class BenchmarkLogService

	def severity_logged? severity

		$num_BLS_sls	+=	1

		(0..100).each { |n| n ** n  }

		:benchmark == severity.to_s.to_sym
	end

	def log sev, t, pref, msg

		puts "BENCHMARK: #{pref}#{msg}\n"
	end
end

class EventLogService

	def severity_logged? severity

		$num_ELS_sls	+=	1

		case severity.to_s.to_sym
		when :notice, :warning, :failure, :critical, :alert, :violation

			true
		when :warn, :error, :emergency

			true
		else

			false
		end
	end

	def log sev, t, pref, msg

		puts "EVENTLOG: #{pref}#{msg}\n"
	end
end

scls		=	Pantheios::Services::SimpleConsoleLogService.new

def scls.severity_logged? severity; ![ :benchmark, :trace, :violation ].include? severity; end

services	=	[

	BenchmarkLogService.new,
	EventLogService.new,
	scls,
]

lcm = :none
#lcm = :thread_fixed
#lcm = :process_fixed
unsync = false
#unsync = true

Pantheios::Core.set_service Pantheios::Services::MultiplexingLogService.new(services, level_cache_mode: lcm, unsyc_process_lcm: unsync)

include Pantheios

t_b	=	Time.now

log :benchmark, 'statement at benchmark'
(0..100000).each { log :trace, 'statement at trace' }
log :debug4, 'statement at debug-4'
log :debug3, 'statement at debug-3'
log :debug2, 'statement at debug-2'
log :debug1, 'statement at debug-1'
log :debug0, 'statement at debug-0'
log :informational, 'statement at informational'
log :notice, 'statement at notice'
log :warning, 'statement at warning'
log :failure, 'statement at failure'
log :critical, 'statement at critical'
log :alert, 'statement at alert'
log :violation, 'statement at violation'

t_a	=	Time.now

$stderr.puts "mode= :#{lcm}; t=#{t_a - t_b}; #BLS=#{$num_BLS_sls}; #ELS=#{$num_ELS_sls}"

