#!/usr/bin/ruby
#
# test abort

$:.unshift File.join(File.dirname(__FILE__), '../..', 'lib')


require 'libclimate'

require 'xqsr3/extensions/test/unit'

require 'test/unit'

require 'stringio'

class Test_Climate_abort < Test::Unit::TestCase

	def test_abort_normal

		strout = StringIO.new
		strerr = StringIO.new

		climate = LibCLImate::Climate.new do |climate|

			climate.program_name	=	'myprog'
			climate.stdout			=	strout
			climate.stderr			=	strerr
		end

		s			=	climate.abort 'something happened', exit: nil

		lines_err	=	strerr.string.split /\n/

		assert_equal 'myprog: something happened', s

		assert_equal 1, lines_err.size
		assert_equal 'myprog: something happened', lines_err[0]
	end

	def test_abort_no_program_name

		strout = StringIO.new
		strerr = StringIO.new

		climate = LibCLImate::Climate.new do |climate|

			climate.program_name	=	'myprog'
			climate.stdout			=	strout
			climate.stderr			=	strerr
		end

		s			=	climate.abort 'something happened', exit: nil, program_name: ''

		lines_err	=	strerr.string.split /\n/

		assert_equal 'something happened', s

		assert_equal 1, lines_err.size
		assert_equal 'something happened', lines_err[0]
	end

	def test_abort_custom_program_name

		strout = StringIO.new
		strerr = StringIO.new

		climate = LibCLImate::Climate.new do |climate|

			climate.program_name	=	'myprog'
			climate.stdout			=	strout
			climate.stderr			=	strerr
		end

		s			=	climate.abort 'something happened', exit: nil, program_name: 'my-prog'

		lines_err	=	strerr.string.split /\n/

		assert_equal 'my-prog: something happened', s

		assert_equal 1, lines_err.size
		assert_equal 'my-prog: something happened', lines_err[0]
	end
end

# ############################## end of file ############################# #


