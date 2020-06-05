#! /usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__), *(['..'] * 1), 'lib')

# requires (0)

require 'pantheios/globals'
require 'pantheios/front_ends/threshold_front_end'
require 'pantheios/services/coloured_console_log_service'

# globals

Pantheios::Globals.INITIAL_SERVICE_CLASSES = [ Pantheios::Services::ColouredConsoleLogService ]
Pantheios::Globals.MAIN_THREAD_NAME = [ Thread.current, 'main' ]
Pantheios::Globals.PROCESS_NAME = :script_stem

# requires (1)

require 'pantheios'

# includes

include ::Pantheios

# constants

LEVELS = %i{ violation alert critical failure warning notice informational debug0 debug1 debug2 debug3 debug4 debug5 trace }

# command-line

abort "USAGE: #$0 <threshold>" unless 1 == ARGV.size

threshold = ARGV[0].to_sym

puts "threshold: :#{threshold}"

Pantheios::Core.set_front_end Pantheios::FrontEnds::ThresholdFrontEnd.new threshold

# main

LEVELS.each do |level|

	log(level, "logging level #{level}")
end

# ############################## end of file ############################# #


