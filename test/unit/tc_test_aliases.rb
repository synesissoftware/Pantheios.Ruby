#!/usr/bin/ruby
#
# test Recls entries

$:.unshift File.join(File.dirname(__FILE__), '../..', 'lib')


require 'libclimate'

require 'xqsr3/extensions/test/unit'

require 'test/unit'

require 'stringio'

class Test_Climate_minimal < Test::Unit::TestCase

	def test_option_with_flag_aliases

		options	=	{}

		climate = LibCLImate::Climate.new do |climate|

			climate.aliases << CLASP.Flag('--action=list', alias: '-l')
			climate.aliases << CLASP.Flag('--action=change', alias: '-c')
			climate.aliases << CLASP.Option('--action', alias: '-a', extras: { handle: Proc.new { |o, a| options[:action] = o.value } })
		end

		# invoke via option
		begin
			options = {}

			argv = %w{ --action=action1 }

			r = climate.run argv

			assert_not_nil r
			assert_kind_of ::Hash, r
			assert_equal 3, r.size
			assert_equal 0, r.flags[:given].size

			assert_equal 1, options.size
			assert_not_nil options[:action]
			assert_equal 'action1', options[:action]
		end

		# invoke via option alias
		begin
			options = {}

			argv = %w{ -a action2 }

			r = climate.run argv

			assert_equal 1, options.size
			assert_not_nil options[:action]
			assert_equal 'action2', options[:action]
		end

		# invoke via flag alias
		begin
			options = {}

			argv = %w{ -c }

			r = climate.run argv

			assert_equal 1, options.size
			assert_not_nil options[:action]
			assert_equal 'change', options[:action]
		end

		# invoke via flag alias
		begin
			options = {}

			argv = %w{ -l }

			r = climate.run argv

			assert_equal 1, options.size
			assert_not_nil options[:action]
			assert_equal 'list', options[:action]
		end
	end
end

# ############################## end of file ############################# #


