#!/usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__), '../../..', 'lib')

require 'pantheios/application_layer/stock_severity_levels'

require 'xqsr3/extensions/test/unit'

require 'test/unit'

class Test_StockSeverityLevels < Test::Unit::TestCase

	include ::Pantheios::ApplicationLayer

	EXPECTED_LEVELS = %w{

		emergency
		alert
		critical
		failure
		warning
		notice
		informational
		debug0
		debug1
		debug2
		debug3
		debug4
		trace
	}.map { |s| s.to_sym }

	def test_StockSeverityLevels_type_exists

		assert defined? StockSeverityLevels
	end

	def test_StockSeverityLevels_type_is_a_module

		assert_kind_of(::Module, StockSeverityLevels) if defined?(StockSeverityLevels)
	end

	def test_StockSeverityLevels_has_constants

		if defined? StockSeverityLevels

			assert StockSeverityLevels.const_defined?(:STOCK_SEVERITY_LEVELS)
			assert StockSeverityLevels.const_defined?(:STOCK_SEVERITY_LEVEL_VALUES)
			assert StockSeverityLevels.const_defined?(:STOCK_SEVERITY_LEVEL_STRINGS)
		end
	end

	def test_StockSeverityLevels_expected_levels

		EXPECTED_LEVELS.each do |sev|

			assert(StockSeverityLevels::STOCK_SEVERITY_LEVELS.include?(sev), "did not find level #{::Symbol === sev ? ':' : ''}#{sev} in #{StockSeverityLevels}::STOCK_SEVERITY_LEVELS")
		end
	end
end

