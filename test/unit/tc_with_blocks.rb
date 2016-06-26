#!/usr/bin/env ruby
#
# test Recls entries

$:.unshift File.join(File.dirname(__FILE__), '../..', 'lib')


require 'libclimate'

require 'xqsr3/extensions/test/unit'

require 'test/unit'

require 'stringio'

class Test_Climate_with_blocks < Test::Unit::TestCase

	def test_flag_with_block

		is_verbose	=	false

		climate = LibCLImate::Climate.new do |climate|

			climate.add_flag('--verbose') { is_verbose = true }
		end

		argv = %w{ --verbose }

		climate.run argv

		assert is_verbose, "block associated with flag '--verbose' was not executed"
	end

	def test_option_with_block

		flavour	=	nil

		climate = LibCLImate::Climate.new do |climate|

			climate.add_option('--flavour') { |o|  flavour = o.value }
		end

		argv = %w{ --flavour=blueberry }

		climate.run argv

		assert_equal 'blueberry', flavour
	end
end

# ############################## end of file ############################# #

