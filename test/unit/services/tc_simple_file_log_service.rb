#!/usr/bin/env ruby
#
# test/unit/services/tc_simple_file_log_service.rb

$:.unshift File.join(File.dirname(__FILE__), '../../..', 'lib')

require 'pantheios/services/simple_file_log_service'

require 'pantheios/application_layer/stock_severity_levels'

require 'xqsr3/extensions/test/unit'

require 'test/unit'

require 'stringio'
require 'tempfile'

class Test_SimpleFileLogservice < Test::Unit::TestCase

	include ::Pantheios::Services

	def test_SimpleFileLogService_type_exists

		assert defined? SimpleFileLogService
	end

	if  defined?(SimpleFileLogService)

		def self.log_to_StringIO_and_get_output messages, def_sev, def_pref = nil, def_t = nil, **options

			def_t		||=	Time.now
			def_pref	||=	"[prog, thread, #{def_t}]: "

			stream		=	StringIO.new

			svc			=	SimpleFileLogService.new stream, **options

			messages.each do |message|

				ar		=	::Array === message ? message : [ message ]

				msg		=	ar[0]
				sev		=	ar[1] || def_sev
				pref	=	ar[2] || def_pref
				t		=	ar[3] || def_t

				svc.log sev, t, pref, msg
			end

			stream.string
		end

		def self.log_to_Tempfile_and_get_output messages, def_sev, def_pref = nil, def_t = nil, **options

			def_t		||=	Time.now
			def_pref	||=	"[prog, thread, #{def_t}]: "

			tf			=	Tempfile.new 'Pantheios.Ruby.Tempfile'

			begin

				svc			=	SimpleFileLogService.new tf, **options

				messages.each do |message|

					ar		=	::Array === message ? message : [ message ]

					msg		=	ar[0]
					sev		=	ar[1] || def_sev
					pref	=	ar[2] || def_pref
					t		=	ar[3] || def_t

					svc.log sev, t, pref, msg
				end

				tf.rewind

				return tf.read
			ensure

				tf.close
				tf.unlink
			end
		end

		def self.log_to_Tempfile_path_and_get_output messages, def_sev, def_pref = nil, def_t = nil, **options

			def_t		||=	Time.now
			def_pref	||=	"[prog, thread, #{def_t}]: "

			tf			=	Tempfile.new 'Pantheios.Ruby.Tempfile'

			begin

				svc			=	SimpleFileLogService.new tf.path, **options

				messages.each do |message|

					ar		=	::Array === message ? message : [ message ]

					msg		=	ar[0]
					sev		=	ar[1] || def_sev
					pref	=	ar[2] || def_pref
					t		=	ar[3] || def_t

					svc.log sev, t, pref, msg
				end

				tf.rewind

				return tf.read
			ensure

				tf.close
				tf.unlink
			end
		end

		def test_SimpleFileLogService_type_is_a_class

			assert_kind_of(::Class, SimpleFileLogService)
		end

		def test_SimpleFileLogService_type_has_expected_instance_methods

			assert_type_has_instance_methods SimpleFileLogService, [ :severity_logged?, :log ]
		end

		def test_ctor_failures_with_invalid_log_file_or_path

			assert_raise_with_message(::ArgumentError, /log_file_or_path.*not.*nil/) { SimpleFileLogService.new nil }

			assert_raise_with_message(::TypeError, [ /log_file_or_path.*must be/, /::File/, /::IO/, /::String/, /::StringIO/ ]) { SimpleFileLogService.new // }
		end

		def test_ctor_failures_with_invalid_options

			assert_raise_with_message(::ArgumentError, /:roll_depth.*non.*negative.*integer/) { SimpleFileLogService.new '/dev/null', roll_depth: true }
			assert_raise_with_message(::ArgumentError, /:roll_depth.*non.*negative.*integer/) { SimpleFileLogService.new '/dev/null', roll_depth: -1 }

			assert_raise_with_message(::ArgumentError, /:roll_size.*non.*negative.*integer/) { SimpleFileLogService.new '/dev/null', roll_size: true }
			assert_raise_with_message(::ArgumentError, /:roll_size.*non.*negative.*integer/) { SimpleFileLogService.new '/dev/null', roll_size: -1 }
		end

		def test_severity_logged_false_with_large_range_of_integers

			output	=	StringIO.new

			svc = SimpleFileLogService.new output

			(-10000 .. 10000).each do |sev|

				assert_true(svc.severity_logged?(sev), "severity '#{sev}' (#{sev.class}) was not logged")
			end
		end

		def test_simple_logging_with_StringIO_1

			message	=	'msg'

			output	=	self.class.log_to_StringIO_and_get_output [ message ], :notice, nil, nil

			lines	=	output.split /\n/

			assert_not_empty lines
			assert_equal 1, lines.size
			assert_match /msg$/, lines[0]
		end

		def test_simple_logging_with_StringIO_2

			msgs	=	[

				[ 'msg-1' ],
				[ 'msg-2' ],
			]

			output	=	self.class.log_to_StringIO_and_get_output msgs, :notice, nil, nil

			lines	=	output.split /\n/

			assert_not_empty lines
			assert_equal 2, lines.size
			assert_match /msg-1$/, lines[0]
			assert_match /msg-2$/, lines[1]
		end

		def test_simple_logging_with_Tempfile_1

			message	=	'msg'

			output	=	self.class.log_to_Tempfile_and_get_output [ message ], :notice, nil, nil

			lines	=	output.split /\n/

			assert_not_empty lines
			assert_equal 1, lines.size
			assert_match /msg$/, lines[0]
		end

		def test_simple_logging_with_Tempfile_2

			msgs	=	[

				[ 'msg-1' ],
				[ 'msg-2' ],
			]

			output	=	self.class.log_to_Tempfile_and_get_output msgs, :notice, nil, nil

			lines	=	output.split /\n/

			assert_not_empty lines
			assert_equal 2, lines.size
			assert_match /msg-1$/, lines[0]
			assert_match /msg-2$/, lines[1]
		end

		def test_simple_logging_with_Tempfile_path_1

			message	=	'msg'

			output	=	self.class.log_to_Tempfile_path_and_get_output [ message ], :notice, nil, nil

			lines	=	output.split /\n/

			assert_not_empty lines
			assert_equal 1, lines.size
			assert_match /msg$/, lines[0]
		end

		def test_simple_logging_with_Tempfile_path_2

			msgs	=	[

				[ 'msg-1' ],
				[ 'msg-2' ],
			]

			output	=	self.class.log_to_Tempfile_path_and_get_output msgs, :notice, nil, nil

			lines	=	output.split /\n/

			assert_not_empty lines
			assert_equal 2, lines.size
			assert_match /msg-1$/, lines[0]
			assert_match /msg-2$/, lines[1]
		end
	end
end


