#!/usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__), '../../..', 'lib')

require 'pantheios/core'

require 'xqsr3/extensions/test/unit'

require 'test/unit'

class Test_Core_set_process_name < Test::Unit::TestCase

	Core = ::Pantheios::Core

	def test_derive_process_name_obtains_the_same_results_but_different_instances

		begin

			Core.process_name = nil

			n_1 = Core.process_name
			n_2 = Core.process_name

			assert_equal n_1, n_2
			assert_same n_1, n_2


			Core.process_name = nil

			n_3 = Core.process_name

			assert_equal n_1, n_3
			assert_not_same n_1, n_3

		ensure

			Core.process_name = nil
		end
	end

	def test_derive_process_name_accepts_custom_value

		begin

			Core.process_name = 'abc'

			assert_equal 'abc', Core.process_name
		ensure

			Core.process_name = nil
		end
	end
end

