#!/usr/bin/env ruby

#############################################################################
# File:         test/performance/test_perf_trace_variants.rb
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

N = 1000000
T = Time.now

def severity_logged? severity

	return ::Pantheios::Core.severity_logged? severity
end


def blank_trace p0, p1, p2, p3, t

	trace
end

def anonymous_trace p0, p1, p2, p3, t

	trace p0, p1, p2, p3, t
end

def parameter_trace p0, p1, p2, p3, t

	trace ParamNames[ :p0, :p1, :p2, :p3, :t ], p0, p1, p2, p3, t
end

def parameter_cond p0, p1, p2, p3, t

	trace ParamNames[ :p0, :p1, :p2, :p3, :t ], p0, p1, p2, p3, t if severity_logged? :trace
end

def names_in_block p0, p1, p2, p3, t

	trace(p0, p1, p2, p3, t) { ParamNames[ :p0, :p1, :p2, :p3, :t ] }
end

def all_in_block p0, p1, p2, p3, t

	trace { [ ParamNames[ :p0, :p1, :p2, :p3, :t ], p0, p1, p2, p3, t ] }
end


Benchmark.benchmark(Benchmark::CAPTION, 24, Benchmark::FORMAT, 'total:', 'avg:') do |r|

	t_log = r.report('plain log') do

		for i in (0...N) do

			log :abc, 'd', 'ef', 't=', T
		end
	end

	t_blank_trace = r.report('blank_trace') do

		for i in (0...N) do

			blank_trace :abc, 'd', 'ef', 't=', T
		end
	end

	t_anonymous_trace = r.report('anonymous_trace') do

		for i in (0...N) do

			anonymous_trace :abc, 'd', 'ef', 't=', T
		end
	end

	t_parameter_trace = r.report('parameter_trace') do

		for i in (0...N) do

			parameter_trace :abc, 'd', 'ef', 't=', T
		end
	end

	t_parameter_cond = r.report('parameter_cond') do

		for i in (0...N) do

			parameter_cond :abc, 'd', 'ef', 't=', T
		end
	end

	t_names_in_block = r.report('names_in_block') do

		for i in (0...N) do

			names_in_block :abc, 'd', 'ef', 't=', T
		end
	end

	t_all_in_block = r.report('all_in_block') do

		for i in (0...N) do

			all_in_block :abc, 'd', 'ef', 't=', T
		end
	end

#	[ at_0 + at_1 + at_2 + bt_0 + bt_1 + bt_2, (at_0 + at_1 + at_2 + bt_0 + bt_1 + bt_2) / 2 ]
end


