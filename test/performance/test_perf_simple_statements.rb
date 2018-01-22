#!/usr/bin/env ruby

#############################################################################
# File:         test/performance/test_perf_simple_statements.rb
#
# Purpose:      COMPLETE_ME
#
# Created:      22nd January 2018
# Updated:      22nd January 2018
#
# Author:       Matthew Wilson
#
# Copyright:    <<TBD>>
#
#############################################################################

$:.unshift File.join(File.dirname(__FILE__), *(['..'] * 2), 'lib')

require 'pantheios/globals'
require 'pantheios/services/null_log_service'

::Pantheios::Globals.INITIAL_SERVICE_CLASSES = [ ::Pantheios::Services::NullLogService ]

require 'pantheios'

require 'benchmark'

include Pantheios

N = 5000000

def severity_logged? severity

	return false
end


Benchmark.benchmark(Benchmark::CAPTION, 24, Benchmark::FORMAT, 'total:', 'avg:') do |r|

	at_0 = r.report("arguments (1-arg)") do

		for i in (0...N) do

			log :notice, 'the cat in the hat.'
		end
	end

	bt_0 = r.report("blocks (1-arg)") do

		for i in (0...N) do

			log(:notice) { 'the cat in the hat!' }
		end
	end

	at_1 = r.report("arguments (simple)") do

		for i in (0...N) do

			log :notice, 'the ', 'cat ', 'in ', 'the ', 'hat.'
		end
	end

	bt_1 = r.report("blocks (simple)") do

		for i in (0...N) do

			log(:notice) { 'the ' + 'cat ' + 'in ' + 'the ' + 'hat!' }
		end
	end

	at_2 = r.report("arguments (complex)") do

		cat	=	'cat'
		hat	=	:hat
		t	=	Time.now

		for i in (0...N) do

			log :notice, "the #{cat} in the #{hat} (#{t})"
		end
	end

	bt_2 = r.report("blocks (complex)") do

		cat	=	'cat'
		hat	=	:hat
		t	=	Time.now

		for i in (0...N) do

			log(:notice) { "the #{cat} in the #{hat} (#{t})" }
		end
	end

	[ at_0 + at_1 + at_2 + bt_0 + bt_1 + bt_2, (at_0 + at_1 + at_2 + bt_0 + bt_1 + bt_2) / 2 ]
end


