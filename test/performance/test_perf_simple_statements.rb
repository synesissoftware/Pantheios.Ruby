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

	totals	=	[]

	totals << r.report("arguments (1-arg)") do

		for i in (0...N) do

			log :notice, 'the cat in the hat.'
		end
	end

	totals << r.report("blocks (1-arg)") do

		for i in (0...N) do

			log(:notice) { 'the cat in the hat!' }
		end
	end

	totals << r.report("args-if (1-arg)") do

		for i in (0...N) do

			log :notice, 'the cat in the hat.' if severity_logged? :notice
		end
	end


	totals << r.report("arguments (simple)") do

		for i in (0...N) do

			log :notice, 'the ', 'cat ', 'in ', 'the ', 'hat.'
		end
	end

	totals << r.report("blocks (simple)") do

		for i in (0...N) do

			log(:notice) { 'the ' + 'cat ' + 'in ' + 'the ' + 'hat!' }
		end
	end

	totals << r.report("args-if (simple)") do

		for i in (0...N) do

			log :notice, 'the ', 'cat ', 'in ', 'the ', 'hat.' if severity_logged? :notice
		end
	end


	totals << r.report("arguments (complex)") do

		cat	=	'cat'
		hat	=	:hat
		t	=	Time.now

		for i in (0...N) do

			log :notice, "the #{cat} in the #{hat} (#{t})"
		end
	end

	totals << r.report("blocks (complex)") do

		cat	=	'cat'
		hat	=	:hat
		t	=	Time.now

		for i in (0...N) do

			log(:notice) { "the #{cat} in the #{hat} (#{t})" }
		end
	end

	totals << r.report("args-if (complex)") do

		cat	=	'cat'
		hat	=	:hat
		t	=	Time.now

		for i in (0...N) do

			log :notice, "the #{cat} in the #{hat} (#{t})" if severity_logged? :notice
		end
	end


	[ totals.inject(:+), totals.inject(:+) / totals.size ]
end


