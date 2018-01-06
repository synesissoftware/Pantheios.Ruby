#!/usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__), '../../..', 'lib')

require 'pantheios/application_layer/stock_severity_levels'

require 'xqsr3/extensions/test/unit'

require 'test/unit'

class Test_StockSeverityLevels < Test::Unit::TestCase

	include ::Pantheios::ApplicationLayer

	EXPECTED_LEVELS_PRIME = %w{

		violation
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

	EXPECTED_LEVELS = %w{

		emergency
		info
		warn
	}.map { |s| s.to_sym } + EXPECTED_LEVELS_PRIME

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

	def test_StockSeverityLevels_expected_prime_levels

		EXPECTED_LEVELS_PRIME.each do |sev|

			assert(StockSeverityLevels::STOCK_SEVERITY_LEVELS_PRIME.include?(sev), "did not find level #{::Symbol === sev ? ':' : ''}#{sev} in #{StockSeverityLevels}::STOCK_SEVERITY_LEVELS")
		end
	end

	def test_StockSeverityLevels_expected_prime_levels_have_distinct_values

		values = {}

		EXPECTED_LEVELS_PRIME.each do |sev|

			value = StockSeverityLevels::STOCK_SEVERITY_LEVEL_VALUES[sev]

			assert(false, "value #{value} for severity '#{sev}' is not unique") if values.has_key?(value)

			values[value] = value
		end
	end

	def test_StockSeverityLevels_expected_prime_levels_have_distinct_strings

		strings = {}

		EXPECTED_LEVELS_PRIME.each do |sev|

			string = StockSeverityLevels::STOCK_SEVERITY_LEVEL_STRINGS[sev]

			assert(false, "string '#{string}' for severity '#{sev}' is not unique") if strings.has_key?(string)

			strings[string] = string
		end
	end
end

