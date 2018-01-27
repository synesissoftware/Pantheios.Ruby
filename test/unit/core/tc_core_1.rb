#!/usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__), '../../..', 'lib')

require 'pantheios/core'

require 'xqsr3/extensions/test/unit'

require 'test/unit'

class Test_Core_set_program_name < Test::Unit::TestCase

	Core = ::Pantheios::Core

	def test_derive_program_name_obtains_the_same_results_but_different_instances

		begin

			Core.program_name = nil

			n_1 = Core.program_name
			n_2 = Core.program_name

			assert_equal n_1, n_2
			assert_same n_1, n_2


			Core.program_name = nil

			n_3 = Core.program_name

			assert_equal n_1, n_3
			assert_not_same n_1, n_3

		ensure

			Core.program_name = nil
		end
	end

	def test_derive_program_name_accepts_custom_value

		begin

			Core.program_name = 'abc'

			assert_equal 'abc', Core.program_name
		ensure

			Core.program_name = nil
		end
	end
end

