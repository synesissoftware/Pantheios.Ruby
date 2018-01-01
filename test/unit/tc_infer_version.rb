#!/usr/bin/env ruby
#
# test version inference

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

		climate = LibCLImate::Climate.new(version_context: self) do |cl|

			cl.program_name		=	'myprog'
			cl.stdout			=	strout

			cl.exit_on_usage	=	false
		end.run [ 'myprog', '--version' ]

		s = strout.string

		assert_equal "myprog 3.22", s.chomp
	end
end

class Test_Climate_infer_version_3_2_99 < Test::Unit::TestCase

	PROGRAM_VER_MINOR		=	2
	PROGRAM_VER_REVISION	=	99

	def test_inference_of_version

		strout = StringIO.new

		climate = LibCLImate::Climate.new(version_context: self) do |cl|

			cl.program_name		=	'myprog'
			cl.stdout			=	strout

			cl.exit_on_usage	=	false
		end.run [ 'myprog', '--version' ]

		s = strout.string

		assert_equal "myprog 3.2.99", s.chomp
	end
end

class Test_Climate_infer_PROGRAM_VERSION_as_array < Test::Unit::TestCase

	PROGRAM_VERSION	=	[ 11, 12, 13 ]

	def test_inference_of_version

		strout = StringIO.new

		climate = LibCLImate::Climate.new(version_context: self) do |cl|

			cl.program_name		=	'myprog'
			cl.stdout			=	strout

			cl.exit_on_usage	=	false
		end.run [ 'myprog', '--version' ]

		s = strout.string

		assert_equal "myprog 11.12.13", s.chomp
	end
end

# ############################## end of file ############################# #


