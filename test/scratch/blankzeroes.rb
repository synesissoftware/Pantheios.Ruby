#!/usr/bin/ruby

#############################################################################
# File:         test/scratch/blankzeroes.rb
#
# Purpose:      COMPLETE_ME
#
# Created:      14 05 2016
# Updated:      14 05 2016
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
PROGRAM_VER_REVISION            =   2

# ##########################################################
# command-line parsing

LibCLImate::Climate.new do |climate|

	climate.version = [ PROGRAM_VER_MAJOR, PROGRAM_VER_MINOR, PROGRAM_VER_REVISION ]
end.run

# ##########################################################
# main

$<.each_line do |line|

	puts line.split(/\t/).map { |s| '0' == s ? '' : s }.join("\t")
end

# ############################## end of file ############################# #

