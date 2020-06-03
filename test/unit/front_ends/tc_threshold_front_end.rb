#!/usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__), '../../..', 'lib')

require 'pantheios/front_ends/threshold_front_end'

require 'test/unit'

class Test_FrontEnds_ThresholdFrontEnd < Test::Unit::TestCase

	include ::Pantheios::FrontEnds

	def test_SimpleConsoleLogService_type_exists

		assert defined? ThresholdFrontEnd
	end

	def test_construct_with_invalid_parameters

		assert_raise(::TypeError) { ThresholdFrontEnd.new('notice') }

		assert_raise_with_message(::ArgumentError, /unknown threshold severity level.*something_else.*Symbol/) { ThresholdFrontEnd.new(:something_else) }

		ThresholdFrontEnd.new(:notice)
		ThresholdFrontEnd.new(:notice, value_lookup_map: Hash.new)
		assert_raise_with_message(::TypeError, /:value_lookup_map must be.*Hash/) { ThresholdFrontEnd.new(:notice, value_lookup_map: Array.new) }
	end

	def test_default_construct

		fe = ThresholdFrontEnd.new(:notice)

		assert_equal :notice, fe.threshold

		assert_true fe.severity_logged?(:violation)
		assert_true fe.severity_logged?(:alert)
		assert_true fe.severity_logged?(:critical)
		assert_true fe.severity_logged?(:failure)
		assert_true fe.severity_logged?(:warning)
		assert_true fe.severity_logged?(:notice)
		assert_false fe.severity_logged?(:informational)
		assert_false fe.severity_logged?(:debug0)
		assert_false fe.severity_logged?(:debug1)
		assert_false fe.severity_logged?(:debug2)
		assert_false fe.severity_logged?(:debug3)
		assert_false fe.severity_logged?(:debug4)
		assert_false fe.severity_logged?(:debug5)
		assert_false fe.severity_logged?(:trace)
	end

	def test_default_construct_and_change_threshold

		fe = ThresholdFrontEnd.new(:notice)

		assert_equal :notice, fe.threshold

		fe.threshold = :failure

		assert_equal :failure, fe.threshold

		assert_true fe.severity_logged?(:violation)
		assert_true fe.severity_logged?(:alert)
		assert_true fe.severity_logged?(:critical)
		assert_true fe.severity_logged?(:failure)
		assert_false fe.severity_logged?(:warning)
		assert_false fe.severity_logged?(:notice)
		assert_false fe.severity_logged?(:informational)
		assert_false fe.severity_logged?(:debug0)
		assert_false fe.severity_logged?(:debug1)
		assert_false fe.severity_logged?(:debug2)
		assert_false fe.severity_logged?(:debug3)
		assert_false fe.severity_logged?(:debug4)
		assert_false fe.severity_logged?(:debug5)
		assert_false fe.severity_logged?(:trace)
	end

	def test_use_custom_thresholds

		value_lookup_map = {

			FATAL: 1,
			ERROR: 2,
			WARN: 3,
			INFO: 4,
			DEBUG: 5,
		}

		fe = ThresholdFrontEnd.new(:INFO, value_lookup_map: value_lookup_map)

		assert_equal :INFO, fe.threshold

		assert_true fe.severity_logged?(:FATAL)
		assert_true fe.severity_logged?(:ERROR)
		assert_true fe.severity_logged?(:WARN)
		assert_true fe.severity_logged?(:INFO)
		assert_false fe.severity_logged?(:DEBUG)
	end
end

# ############################## end of file ############################# #


