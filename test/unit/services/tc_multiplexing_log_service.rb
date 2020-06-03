#!/usr/bin/env ruby
#
# test/unit/services/tc_multiplexing_log_service.rb

$:.unshift File.join(File.dirname(__FILE__), '../../..', 'lib')

require 'pantheios/services/multiplexing_log_service'

require 'pantheios/api'
require 'pantheios/application_layer/stock_severity_levels'

require 'xqsr3/extensions/test/unit'

require 'test/unit'

require 'stringio'

class Test_MultiplexingLogservice < Test::Unit::TestCase

	include ::Pantheios::API
	include ::Pantheios::Services

	class ProgrammableLogService

		def initialize name, severities

			@name		=	name
			@severities	=	severities
			@items		=	[]
		end

		attr_reader :name
		attr_reader :items

		def severity_logged? severity

			@severities.include? severity
		end

		def log sev, t, pref, msg

			@items << [ sev, t, pref, msg ]
		end
	end

	def log_multiple_statements svc

		previous, _	=	Pantheios::Core.set_service svc

		begin

			severities	=	Pantheios::ApplicationLayer::StockSeverityLevels::STOCK_SEVERITY_LEVELS_PRIME

			severities.each do |sev|

				log sev, "a(n) #{sev} statement"
			end
		ensure

			Pantheios::Core.set_service previous
		end
	end


	def test_MultiplexingLogService_type_exists

		assert defined? MultiplexingLogService
	end

	if  defined?(MultiplexingLogService)

		def test_MultiplexingLogService_type_is_a_class

			assert_kind_of(::Class, MultiplexingLogService)
		end

		def test_MultiplexingLogService_type_has_expected_instance_methods

			assert_type_has_instance_methods MultiplexingLogService, [ :severity_logged?, :log ]
		end

		def test_multiplex_1

			svc_0		=	ProgrammableLogService.new 'svc_0', Pantheios::ApplicationLayer::StockSeverityLevels::STOCK_SEVERITY_LEVELS_PRIME - [ :informational, :notice, :trace ]
			svc_1		=	ProgrammableLogService.new 'svc_1', [ :informational, :notice, :warning, :failure ]
			svc_2		=	ProgrammableLogService.new 'svc_2', [ :informational, :debug0, :debug1, :debug2, :debug3, :debug4 ]

			svc			=	MultiplexingLogService.new [ svc_0, svc_1, svc_2 ]

			log_multiple_statements svc

			assert_equal 12, svc_0.items.size
			assert_equal  4, svc_1.items.size
			assert_equal  6, svc_2.items.size
		end

		def test_multiplex_2

			svc_0		=	ProgrammableLogService.new 'svc_0', Pantheios::ApplicationLayer::StockSeverityLevels::STOCK_SEVERITY_LEVELS_PRIME - [ :informational, :notice, :trace ]
			svc_1		=	ProgrammableLogService.new 'svc_1', [ :informational, :notice, :warning, :failure ]
			svc_2		=	ProgrammableLogService.new 'svc_2', [ :informational, :debug0, :debug1, :debug2, :debug3, :debug4 ]

			svc			=	MultiplexingLogService.new [ svc_0, svc_1, svc_2 ], level_cache_mode: :none

			log_multiple_statements svc

			assert_equal 12, svc_0.items.size
			assert_equal  4, svc_1.items.size
			assert_equal  6, svc_2.items.size
		end

		def test_multiplex_3

			svc_0		=	ProgrammableLogService.new 'svc_0', Pantheios::ApplicationLayer::StockSeverityLevels::STOCK_SEVERITY_LEVELS_PRIME - [ :informational, :notice, :trace ]
			svc_1		=	ProgrammableLogService.new 'svc_1', [ :informational, :notice, :warning, :failure ]
			svc_2		=	ProgrammableLogService.new 'svc_2', [ :informational, :debug0, :debug1, :debug2, :debug3, :debug4 ]

			svc			=	MultiplexingLogService.new [ svc_0, svc_1, svc_2 ], level_cache_mode: :process_fixed

			log_multiple_statements svc

			assert_equal 12, svc_0.items.size
			assert_equal  4, svc_1.items.size
			assert_equal  6, svc_2.items.size
		end

		def test_multiplex_4

			svc_0		=	ProgrammableLogService.new 'svc_0', Pantheios::ApplicationLayer::StockSeverityLevels::STOCK_SEVERITY_LEVELS_PRIME - [ :informational, :notice, :trace ]
			svc_1		=	ProgrammableLogService.new 'svc_1', [ :informational, :notice, :warning, :failure ]
			svc_2		=	ProgrammableLogService.new 'svc_2', [ :informational, :debug0, :debug1, :debug2, :debug3, :debug4 ]

			svc			=	MultiplexingLogService.new [ svc_0, svc_1, svc_2 ], level_cache_mode: :thread_fixed

			log_multiple_statements svc

			assert_equal 12, svc_0.items.size
			assert_equal  4, svc_1.items.size
			assert_equal  6, svc_2.items.size
		end
	end
end


