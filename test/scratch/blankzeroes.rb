#!/usr/bin/ruby

#############################################################################
# File:         test/scratch/blankzeroes.rb
#
# Purpose:      This filter program converts 0 values in a TSV into blanks
#
# Created:      14th May 2016
# Updated:      5th February 2018
#
# Author:       Matthew Wilson
#
# Copyright:    <<TBD>>
#
#############################################################################

$:.unshift File.join(File.dirname(__FILE__), '../..', 'lib')


require 'libclimate'

# ##########################################################
# constants

PROGRAM_VER_MAJOR               =   0
PROGRAM_VER_MINOR               =   1
PROGRAM_VER_REVISION            =   3
PROGRAM_VER_BUILD               =   5

# ##########################################################
# command-line parsing

LibCLImate::Climate.new do |cl|

	cl.info_lines = [

		:version,
		'converts 0 values into blanks',
	]
end.run

# ##########################################################
# main

$<.each_line do |line|

	puts line.split(/\t/).map { |s| '0' == s ? '' : s }.join("\t")
end

# ############################## end of file ############################# #


