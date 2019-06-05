#!/usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__), *([ '..' ] * 1), 'lib')

# requires (0)

require 'pantheios/globals'

# globals

Pantheios::Globals.MAIN_THREAD_NAME = [ Thread.current, 'main' ]
Pantheios::Globals.PROCESS_NAME = :script_stem

# requires (1)

require 'pantheios'

# includes

include ::Pantheios

# constants

LEVELS = %i{ violation alert critical failure warning notice informational debug0 debug1 debug2 debug3 debug4 }

# main

LEVELS.each do |level|

	log(level, "logging level #{level}")
end

# ############################## end of file ############################# #


