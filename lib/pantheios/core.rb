
# ######################################################################## #
# File:         lib/pantheios/core.rb
#
# Purpose:      The Pantheios.Ruby core (::Pantheios::Core)
#
# Created:      2nd April 2011
# Updated:      8th January 2018
#
# Home:         http://github.com/synesissoftware/Pantheios-Ruby
#
# Author:       Matthew Wilson
#
# Copyright (c) 2011-2018, Matthew Wilson and Synesis Software
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
# * Redistributions of source code must retain the above copyright
#   notice, this list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in the
#   documentation and/or other materials provided with the distribution.
#
# * Neither the names of the copyright holder nor the names of its
#   contributors may be used to endorse or promote products derived from
#   this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
# IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# ######################################################################## #


require 'pantheios/globals'

require 'pantheios/application_layer/stock_severity_levels'
require 'pantheios/util/process_util'

require 'pantheios/services/simple_console_log_service'

=begin
=end

module Pantheios
module Core

	module Constants_

		REQUIRED_SERVICE_METHODS	=	%w{ severity_logged? log }.map { |name| name.to_sym }
		REQUIRED_FRONTEND_METHODS	=	%w{ severity_logged?     }.map { |name| name.to_sym }
		REQUIRED_BACKEND_METHODS	=	%w{                  log }.map { |name| name.to_sym }

	end # module Constants_

	module Internals_

		class DefaultDiscriminator

			def severity_logged? severity

				return true if $DEBUG

				levels	=	::Pantheios::ApplicationLayer::StockSeverityLevels::STOCK_SEVERITY_LEVEL_VALUES

				v_info	=	levels[:informational]
				v_sev	=	levels[severity] if ::Symbol === severity

				return false if v_sev > v_info

				true
			end
		end

		# :nodoc:
		class State

			def initialize default_fe

				@mx_service			=	Mutex.new
				@front_end			=	nil
				@back_end			=	nil
				@requires_prefix	=	false;
				@default_fe			=	default_fe
			end

			def set_front_end fe

				raise ::TypeError, "front-end instance (#{fe.class}) does not respond to all the required messages (#{Constants_::REQUIRED_FRONTEND_METHODS.join(', ')})" unless fe && Constants_::REQUIRED_FRONTEND_METHODS.all? { |m| fe.respond_to? m }

				r	=	nil

				fe	||=	@default_fe

				@mx_service.synchronize do

					r, @front_end = @front_end, fe
				end

				r = nil if r.object_id == @default_fe.object_id

				return r
			end

			def set_back_end be

				raise ::TypeError, "back-end instance (#{fe.class}) does not respond to all the required messages (#{Constants_::REQUIRED_BACKEND_METHODS.join(', ')})" unless be && Constants_::REQUIRED_BACKEND_METHODS.all? { |m| be.respond_to? m }

				r	=	nil
				srp	=	svc.respond_to?(:requires_prefix?) ? svc.requires_prefix? : true

				@mx_service.synchronize do

					r, @back_end, @requires_prefix = @back_end, be, srp
				end

				return r
			end

			def set_service svc

				raise ::TypeError, "service instance (#{svc.class}) does not respond to all the required messages (#{Constants_::REQUIRED_SERVICE_METHODS.join(', ')})" unless svc && Constants_::REQUIRED_SERVICE_METHODS.all? { |m| svc.respond_to? m }

				r	=	[]
				srp	=	svc.respond_to?(:requires_prefix?) ? svc.requires_prefix? : true

				@mx_service.synchronize do

					r << @front_end
					r << @back_end

					@front_end, @back_end, @requires_prefix = svc, svc, srp
				end

				return r
			end

			def severity_logged? severity

				@mx_service.synchronize do

					return nil unless @front_end

					@front_end.severity_logged? severity
				end
			end

			def log

			end

			def discriminator

				@mx_service.synchronize do

					if @service && @service.respond_to?(:severity_logged?)

						return @service
					end

					@front_end
				end
			end

			attr_reader	:service
			attr_reader	:front_end
			attr_reader	:back_end
			def requires_prefix?; @requires_prefix; end
		end
	end # module Internals_

	def self.included receiver

		abort "Attempt to include #{self} into #{receiver}. This is not allowed"
	end

	# :nodoc:
	def self.core_init

		@@state = Internals_::State.new Internals_::DefaultDiscriminator.new

		self.set_default_service
	end

	# :nodoc:
	def self.set_default_service **options

		# determine which log service to initialise as the default

		(::Pantheios::Globals.INITIAL_SERVICE_INSTANCES || []).each do |inst|

			next unless inst

			return @@state.set_service inst
		end

		(::Pantheios::Globals.INITIAL_SERVICE_CLASSES || []).each do |cls|

			inst = cls.new

			return @@state.set_service inst
		end

		@@state.set_service ::Pantheios::Services::SimpleConsoleLogService.new
	end

	# Sets the front-end that will be used to evaluate whether a given log
	# statement will be logged
	#
	# * *Parameters:*
	#   - +fe+ The front-end instance. It must respond to the
	#     +severity_logged?+ message, or a ::TypeError will be raised
	#
	# * *Returns:*
	#   The previously registered instance, or +nil+ if no previous one was
	#   registered
	def self.set_front_end fe

		@@state.set_front_end fe
	end

	# Sets the back-end used to emit the given log statement
	#
	# * *Parameters:*
	#   - +be+ The back-end instance. It must respond to the
	#     +log+ message, or a ::TypeError will be raised. It may also respond
	#     to the +requires_prefix?+ message, which can be used to indicate
	#     whether a prepared prefix is required; if not present, the
	#     framework assumes that the back-end requires a prefix
	#
	# * *Returns:*
	#   The previously registered instance, or +nil+ if no previous one was
	#   registered
	def self.set_back_end be

		@@state.set_back_end be
	end

	# Sets the service that will be used to evaluate whether a given log
	# statement will be logged and to emit it
	#
	# * *Parameters:*
	#   - +svc+ The service instance. It must respond to the
	#     +severity_logged?+ and +log+ messages, or a ::TypeError will be
	#     raised.  It may also respond to the +requires_prefix?+ message,
	#     which can be used to indicate whether a prepared prefix is
	#     required; if not present, the framework assumes that the service
	#     (back-end) requires a prefix
	#
	# * *Returns:*
	#   An array of two elements, representing the previous front-end and
	#   previous back-end
	def self.set_service svc

		@@state.set_service svc
	end

	self.core_init

	# :nodoc:
	def self.register_include includee, includer

		$stderr.puts "#{includee} included into #{includer}" if $DEBUG
	end

	# Default implementation to determine whether the given severity is
	# logged
	#
	# * *Returns:*
	#   If +$DEBUG+ is +true+, then returns +true+ - all statements are
	#   emitted in debug mode. In normal operation, if the integral value of
	#   +severity+ is greater than that of +:informational+ then it returns
	#   +false+; otherwise it return +true+
	def self.severity_logged? severity

		@@state.severity_logged? severity
	end

	# Default implementation to obtain the process id
	#
	# * *Returns:*
	#   +Process.pid+
	def self.process_id

		Process.pid
	end

	# Default implementation to obtain the program name
	#
	# * *Returns:*
	#   The file stem of +$0+
	#
	# NOTE: this is implemented in terms of Process_Util.derive_process_name
	# and the result is cached
	def self.program_name

		@program_name ||= ::Pantheios::Util::ProcessUtil.derive_process_name $0
	end

	def self.severity_string severity

		r = ApplicationLayer::StockSeverityLevels::STOCK_SEVERITY_LEVEL_STRINGS[severity] and return r

		severity.to_s
	end

	# Default implementation to obtain the thread_id
	#
	# * *Returns:*
	#   From the current thread either the value obtained via the attribute
	#   +thread_name+ (if it responds to that) or via +object_id+
	def self.thread_id

		t = Thread.current

		return t.thread_name if t.respond_to? :thread_name

		t.object_id
	end

	def self.timestamp_format

		'%Y-%m-%d %H:%M:%S.%6N'
	end

	# Default implementation to obtain the timestamp according to a given
	# format
	#
	# * *Parameters:*
	#  - +t+ [::Time] The time
	#  - +fmt+ [::String, nil] The format to be used. If +nil+ the value
	#    obtained by +timestamp_format+ is used
	#
	# * *Returns:*
	#   A string representing the time
	def self.timestamp t, fmt

		fmt ||= self.timestamp_format

		t.strftime fmt
	end


	# Internal implementation method, not to be called by application code
	def self.trace_v_prep prefix_provider, call_depth, argv

		if ApplicationLayer::ParamNameList === argv[0]

			self.trace_v_impl prefix_provider, 1 + call_depth, argv[0], :trace, argv[1..-1]
		else

			self.trace_v_impl prefix_provider, 1 + call_depth, nil, :trace, argv
		end
	end

	# Internal implementation method, not to be called by application code
	def self.trace_v_impl prefix_provider, call_depth, param_list, severity, argv

		case param_list
		when nil
			;
		when ApplicationLayer::ParamNameList
			;
		else

			warn "param_list (#{param_list.class}) must be nil or an instance of #{ApplicationLayer::ParamNameList}" unless param_list
		end

		fl	=	nil
		rx	=	nil
		fn	=	caller(call_depth + 1, 1)[0]

		if ::Class === prefix_provider

			rx	=	"#{prefix_provider}::"
		else

			rx	=	"#{prefix_provider.class}#"
		end

		if false;
		elsif fn =~ /(.+)\:in\s*\`(.+)\'\s*$/

			fl	=	$1
			fn	=	$2

			f	=	"#{fl}: #{rx}#{fn}"
		elsif fn =~ /.*in\s*\`(.+)\'\s*$/

			f	=	$1
		else

			f	=	fn
		end

		if param_list

			sig = ''

			argv.each_with_index do |arg, index0|

				n	=	param_list[index0]

				s	=	arg.to_s
				s	=	"'#{s}'" if s.index(/[,\s]/)

				sig	+=	', ' unless sig.empty?

				sig	+=	n ? "#{n} (#{arg.class})=#{s}" : s
			end
		else

			sig = argv.join(', ')
		end

		stmt = "#{f}(#{sig})"

		self.log_raw prefix_provider, severity, stmt
	end

	# Internal implementation method, not to be called by application code
	def self.log_raw prefix_provider, severity, message

		now	=	Time.now

		prf	=	@@state.requires_prefix? ? '[' + prefix_provider.prefix(now, severity) + ']: ' : nil

		@@state.back_end.log severity, now, prf, message
	end

end # Core
end # Pantheios

# ############################## end of file ############################# #


