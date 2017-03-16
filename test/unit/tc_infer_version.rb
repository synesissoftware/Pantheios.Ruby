#!/usr/bin/env ruby

#

$:.unshift File.join(File.dirname(__FILE__), '../..', 'lib')


require 'libclimate'

require 'xqsr3/extensions/test/unit'

require 'test/unit'

require 'stringio'

PROGRAM_VER_MAJOR	=	3

class Test_Climate_infer_version_3_22 < Test::Unit::TestCase

	PROGRAM_VER_MINOR	=	22

	def test_inference_of_version

		strout = StringIO.new

		climate = LibCLImate::Climate.new do |climate|

			climate.program_name	=	'myprog'
			climate.stdout			=	strout
		end.run [ 'myprog', '--version' ]

		s = strout.string

		assert_equal "myprog 3.22", s
	end
end

class Test_Climate_infer_version_3_2 < Test::Unit::TestCase

	PROGRAM_VER_MINOR		=	2
	PROGRAM_VER_REVISION	=	99

	def test_inference_of_version

		strout = StringIO.new

		climate = LibCLImate::Climate.new do |climate|

			climate.program_name	=	'myprog'
			climate.stdout			=	strout
		end.run [ 'myprog', '--version' ]

		s = strout.string

		assert_equal "myprog 3.2.99", s
	end
end

# ############################## end of file ############################# #


