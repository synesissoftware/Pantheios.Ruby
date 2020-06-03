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
		debug5
		trace
		benchmark
	}.map { |s| s.to_sym }

	EXPECTED_LEVELS = %w{

		emergency
		fail
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
			assert StockSeverityLevels.const_defined?(:STOCK_SEVERITY_LEVELS_PRIME)
			assert StockSeverityLevels.const_defined?(:STOCK_SEVERITY_LEVEL_VALUES)
			assert StockSeverityLevels.const_defined?(:STOCK_SEVERITY_LEVEL_STRINGS)
		end
	end

	def test_StockSeverityLevels_expected_levels

		# all the ones that we expect exist

		EXPECTED_LEVELS.each do |sev|

			assert(StockSeverityLevels::STOCK_SEVERITY_LEVELS.include?(sev), "did not find level #{::Symbol === sev ? ':' : ''}#{sev} in #{StockSeverityLevels}::STOCK_SEVERITY_LEVELS")
		end

		# we expect all the ones that exist

		StockSeverityLevels::STOCK_SEVERITY_LEVELS.each do |sev|

			assert(EXPECTED_LEVELS.include?(sev), "found unexpected level #{::Symbol === sev ? ':' : ''}#{sev} in #{StockSeverityLevels}::STOCK_SEVERITY_LEVELS")
		end
	end

	def test_StockSeverityLevels_expected_prime_levels

		# all the ones that we expect exist

		EXPECTED_LEVELS_PRIME.each do |sev|

			assert(StockSeverityLevels::STOCK_SEVERITY_LEVELS_PRIME.include?(sev), "did not find level #{::Symbol === sev ? ':' : ''}#{sev} in #{StockSeverityLevels}::STOCK_SEVERITY_LEVELS")
		end

		# we expect all the ones that exist

		StockSeverityLevels::STOCK_SEVERITY_LEVELS_PRIME.each do |sev|

			assert(EXPECTED_LEVELS_PRIME.include?(sev), "found unexpected level #{::Symbol === sev ? ':' : ''}#{sev} in #{StockSeverityLevels}::STOCK_SEVERITY_LEVELS")
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

	def test_StockSeverityLevels_aliases

		aliases = StockSeverityLevels::STOCK_SEVERITY_LEVEL_ALIASES

		assert_equal :violation, aliases[:violation]
		assert_equal :violation, aliases[:emergency]

		assert_equal :alert, aliases[:alert]

		assert_equal :critical, aliases[:critical]

		assert_equal :failure, aliases[:failure]
		assert_equal :failure, aliases[:fail]
		#assert_equal :failure, aliases[:error]

		assert_equal :warning, aliases[:warning]
		assert_equal :warning, aliases[:warn]

		assert_equal :notice, aliases[:notice]

		assert_equal :informational, aliases[:informational]
		assert_equal :informational, aliases[:info]

		%i{ debug0 debug1 debug2 debug3 debug4 debug5 }.each do |sev|

			assert_equal sev, aliases[sev]
		end

		assert_equal :trace, aliases[:trace]

		assert_equal :benchmark, aliases[:benchmark]
	end

	def test_StockSeverityLevels_recognised_values_are_nil

		EXPECTED_LEVELS.each do |sev|

			assert_not_nil StockSeverityLevels::STOCK_SEVERITY_LEVEL_VALUES[sev]
			assert_nil StockSeverityLevels::STOCK_SEVERITY_LEVEL_VALUES[sev.to_s]
		end

		assert_nil StockSeverityLevels::STOCK_SEVERITY_LEVEL_VALUES[nil]
		assert_nil StockSeverityLevels::STOCK_SEVERITY_LEVEL_VALUES['failure']
	end
end

