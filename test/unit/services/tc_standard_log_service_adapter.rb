#!/usr/bin/env ruby
#
# test/unit/services/tc_standard_log_service.rb

$:.unshift File.join(File.dirname(__FILE__), '../../..', 'lib')

require 'pantheios/services/standard_log_service_adapter'

require 'pantheios/application_layer/stock_severity_levels'

require 'pantheios/util/process_util'

require 'xqsr3/extensions/test/unit'

require 'test/unit'

require 'stringio'

class Test_StandardLogservice < Test::Unit::TestCase

	include ::Pantheios::Services

	STOCK_SEVERITY_LEVEL_VALUES = ::Pantheios::ApplicationLayer::StockSeverityLevels::STOCK_SEVERITY_LEVEL_VALUES

	def test_StandardLogServiceAdapter_type_exists

		assert defined? StandardLogServiceAdapter
	end

	if  defined?(StandardLogServiceAdapter)

		def test_StandardLogServiceAdapter_type_is_a_class

			assert_kind_of(::Class, StandardLogServiceAdapter)
		end

		def test_StandardLogServiceAdapter_type_has_expected_instance_methods

			assert_type_has_instance_methods StandardLogServiceAdapter, [ :severity_logged?, :log ]
		end

		def test_severity_logged

			logdev	=	StringIO.new
			logger	=	::Logger.new logdev

			svc		=	StandardLogServiceAdapter.new logger

			logger.level	=	::Logger::WARN

			assert_false svc.severity_logged?(:debug4)
			assert_false svc.severity_logged?(:debug3)
			assert_false svc.severity_logged?(:debug2)
			assert_false svc.severity_logged?(:debug1)
			assert_false svc.severity_logged?(:debug0)
			assert_false svc.severity_logged?(:informational)
			assert_false svc.severity_logged?(:notice)
			assert_true svc.severity_logged?(:warning)
			assert_true svc.severity_logged?(:failure)
			assert_true svc.severity_logged?(:critical)
			assert_true svc.severity_logged?(:alert)
			assert_true svc.severity_logged?(:violation)

			assert_true svc.severity_logged?(nil)

			assert_false svc.severity_logged?(STOCK_SEVERITY_LEVEL_VALUES[:debug4])
			assert_false svc.severity_logged?(STOCK_SEVERITY_LEVEL_VALUES[:debug3])
			assert_false svc.severity_logged?(STOCK_SEVERITY_LEVEL_VALUES[:debug2])
			assert_false svc.severity_logged?(STOCK_SEVERITY_LEVEL_VALUES[:debug1])
			assert_false svc.severity_logged?(STOCK_SEVERITY_LEVEL_VALUES[:debug0])
			assert_false svc.severity_logged?(STOCK_SEVERITY_LEVEL_VALUES[:informational])
			assert_false svc.severity_logged?(STOCK_SEVERITY_LEVEL_VALUES[:notice])
			assert_true svc.severity_logged?(STOCK_SEVERITY_LEVEL_VALUES[:warning])
			assert_true svc.severity_logged?(STOCK_SEVERITY_LEVEL_VALUES[:failure])
			assert_true svc.severity_logged?(STOCK_SEVERITY_LEVEL_VALUES[:critical])
			assert_true svc.severity_logged?(STOCK_SEVERITY_LEVEL_VALUES[:alert])
			assert_true svc.severity_logged?(STOCK_SEVERITY_LEVEL_VALUES[:violation])
		end

		def test_selected_log_with_default_format

			logdev	=	StringIO.new
			logger	=	::Logger.new logdev

			svc		=	StandardLogServiceAdapter.new logger

			logger.level	=	::Logger::WARN

			t		=	Time.now
			pid		=	Process.pid
			prname	=	::Pantheios::Util::ProcessUtil.derive_process_name

			[ :notice, :warning, :critical ].each do |level|

				svc.log level, t, nil, "a message at #{level}" if svc.severity_logged? level
			end

			svc.flush if svc.respond_to? :flush

			res		=	logdev.string.split /\n/

			assert_equal 2, res.size

			assert_match /W\s*,\s*\[.*##{pid}\s*\]\s*WARN\s*--\s*#{prname}\s*:\s*a message at warning/, res[0]
			assert_match /E\s*,\s*\[.*##{pid}\s*\]\s*ERROR\s*--\s*#{prname}\s*:\s*a message at critical/, res[1]
		end

		def test_selected_log_with_blank_format

			logdev	=	StringIO.new
			logger	=	::Logger.new logdev

			svc		=	StandardLogServiceAdapter.new logger, format: :simple

			logger.level	=	::Logger::WARN

			t		=	Time.now

			[ :notice, :warning, :critical ].each do |level|

				svc.log level, t, nil, "a message at #{level}" if svc.severity_logged? level
			end

			svc.flush if svc.respond_to? :flush

			res		=	logdev.string.split /\n/

			assert_equal 2, res.size

			assert_equal 'a message at warning', res[0]
			assert_equal 'a message at critical', res[1]
		end

		def test_selected_log_with_standard_format

			logdev	=	StringIO.new
			logger	=	::Logger.new logdev

			svc		=	StandardLogServiceAdapter.new logger, format: :standard

			logger.level	=	::Logger::WARN

			t		=	Time.now
			pid		=	Process.pid
			tid		=	Thread.current.object_id
			prname	=	::Pantheios::Util::ProcessUtil.derive_process_name
			ts		=	t.strftime '%Y-%m-%d %H:%M:%S.%6N'

			[ :notice, :warning, :critical ].each do |level|

				pref = "[#{prname} #{tid} #{ts} #{level}]"

				svc.log level, t, pref, "a message at #{level}" if svc.severity_logged? level
			end

			svc.flush if svc.respond_to? :flush

			res		=	logdev.string.split /\n/

			assert_equal 2, res.size

			assert_match /\s*\[\s*#{prname} #{tid} #{ts} warning\s*\]\s*a message at warning/, res[0]
			assert_match /\s*\[\s*#{prname} #{tid} #{ts} critical\s*\]\s*a message at critical/, res[1]
		end
	end
end


