#!/usr/bin/env ruby

#############################################################################
# File:         test/scratch/log_using_blocks.rb
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

require 'pantheios'

include Pantheios

log :notice, 'program starting ...'

log(:notice) { 'program started' }

def f param0, param1

	trace

	log :trace

	trace param0, param1

	log :trace, param0, param1

	trace ParamNames[ :param0, :param1 ], param0, param1

	log :trace, ParamNames[ :param0, :param1 ], param0, param1

	trace { [ ParamNames[ :param0, :param1 ], param0, param1 ] }
end

def g param0, param1

	trace(param0, param1) { [ ParamNames[ :param0, :param1 ]] }

	f param0, param1
end

def h param0, param1, param2

	trace(param0, param1, param2) { ParamNames[ :param0, :param1, :param2 ] }

	g param0, param1
end


f :abc, 'def'

puts

g :ghi, 'k'

puts

h 'lmnop', :q, :rst


