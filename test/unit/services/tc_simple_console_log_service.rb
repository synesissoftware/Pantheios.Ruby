#!/usr/bin/env ruby
#
# test/unit/services/tc_simple_console_log_service.rb

$:.unshift File.join(File.dirname(__FILE__), '../../..', 'lib')

require 'pantheios/services/simple_console_log_service'

require 'pantheios/application_layer/stock_severity_levels'

require 'xqsr3/extensions/test/unit'

require 'test/unit'

require 'stringio'

class Test_SimpleConsoleLogservice < Test::Unit::TestCase

	include ::Pantheios::Services

	def test_SimpleConsoleLogService_type_exists

		assert defined? SimpleConsoleLogService
	end

	if  defined?(SimpleConsoleLogService)

		def test_SimpleConsoleLogService_type_is_a_class

			assert_kind_of(::Class, SimpleConsoleLogService)
		end

		def test_SimpleConsoleLogService_type_has_expected_instance_methods

			assert_type_has_instance_methods SimpleConsoleLogService, [ :severity_logged?, :log ]
		end

		def test_severity_logged_false_with_large_range_of_integers

			svc = SimpleConsoleLogService.new

			(-10000 .. 10000).each do |sev|

				assert_true(svc.severity_logged?(sev), "severity '#{sev}' (#{sev.class}) was not logged")
			end
		end

		def test_severity_logged_false_with_stock_severity_levels

			svc = SimpleConsoleLogService.new

			::Pantheios::ApplicationLayer::StockSeverityLevels::STOCK_SEVERITY_LEVELS.each do |sev|

				assert_true(svc.severity_logged?(sev), "severity '#{sev}' (#{sev.class}) was not logged")
			end
		end

		def test_log_writes_to_standard_streams

			prev_stdout, prev_stderr = $stdout, $stderr

			begin

				$stdout	=	StringIO.new
				$stderr	=	StringIO.new

				svc		=	SimpleConsoleLogService.new
				t		=	Time.now

				(-1000..1000).each do |sev|

					svc.log sev, t, 'some-prefix', 'some-message'
				end

				stdout_s	=	$stdout.string
				stderr_s	=	$stderr.string

				assert_not_empty stdout_s, "NullLogService has not written to $stdout!"
				assert_not_empty stderr_s, "NullLogService has not written to $stderr!"
			ensure

				$stdout, $stderr = prev_stdout, prev_stderr
			end
		end
	end
end


