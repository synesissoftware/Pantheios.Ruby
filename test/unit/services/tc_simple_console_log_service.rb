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

		def self.log_and_get_streams sev, msg, pref = nil, t = nil

			prev_stdout, prev_stderr = $stdout, $stderr

			begin

				$stdout	=	StringIO.new
				$stderr	=	StringIO.new

				svc		=	SimpleConsoleLogService.new
				t		||=	Time.now

				svc.log sev, t, pref, msg

				[ $stdout.string, $stderr.string ]
			ensure

				$stdout, $stderr = prev_stdout, prev_stderr
			end
		end

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

				assert_empty stdout_s, "SimpleConsoleLogService has written to $stdout!"
				assert_not_empty stderr_s, "SimpleConsoleLogService has not written to $stderr!"
			ensure

				$stdout, $stderr = prev_stdout, prev_stderr
			end
		end

		def test_writing_to_streams_based_on_severities

			r	=	nil

			stderr_levels = %w{ violation emergency alert critical failure warning warn }.map { |s| s.to_sym }
			stdout_levels = %w{ notice informational info debug0 debug1 debug2 debug3 debug4 trace }.map { |s| s.to_sym }

			stderr_levels.each do |sev|

				r	=	self.class.log_and_get_streams sev, 'msg'

				assert_empty r[0], "SimpleConsoleLogService wrote unexpectedly to $stdout for severity #{sev}"
				assert_not_empty r[1], "SimpleConsoleLogService failed to write to $stderr for severity #{sev}"
			end

			stdout_levels.each do |sev|

				r	=	self.class.log_and_get_streams sev, 'msg'

				assert_empty r[0], "SimpleConsoleLogService wrote to $stdout for severity #{sev}"
				assert_not_empty r[1], "SimpleConsoleLogService failed to write to $stderr for severity #{sev}"
			end
		end
	end
end


