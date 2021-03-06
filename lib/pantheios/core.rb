
# ######################################################################## #
# File:         lib/pantheios/core.rb
#
# Purpose:      The Pantheios.Ruby core (::Pantheios::Core)
#
# Created:      2nd April 2011
# Updated:      4th June 2020
#
# Home:         http://github.com/synesissoftware/Pantheios-Ruby
#
# Author:       Matthew Wilson
#
# Copyright (c) 2019-2020, Matthew Wilson and Synesis Information Systems
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

require 'pantheios/services/simple_console_log_service'

require 'pantheios/util/process_util'
require 'pantheios/util/reflection_util'
require 'pantheios/util/thread_util'

=begin
=end

module Pantheios
module Core

	# @!visibility private
	module Constants_ # :nodoc: all

		REQUIRED_SERVICE_METHODS	=	%w{ severity_logged? log }.map { |name| name.to_sym }
		REQUIRED_FRONTEND_METHODS	=	%w{ severity_logged?     }.map { |name| name.to_sym }
		REQUIRED_BACKEND_METHODS	=	%w{                  log }.map { |name| name.to_sym }

	end # module Constants_

	# @!visibility private
	module Internals_ # :nodoc: all

		# @!visibility private
		class DefaultDiscriminator # :nodoc:

			def severity_logged? severity

				return true if $DEBUG

				levels	=	::Pantheios::ApplicationLayer::StockSeverityLevels::STOCK_SEVERITY_LEVEL_VALUES

				v_info	=	levels[:informational]
				v_sev	=	levels[severity] if ::Symbol === severity

				return false if v_sev > v_info

				true
			end
		end

		# @!visibility private
		class State # :nodoc:

			def initialize default_fe, **options

				@mx_service			=	Mutex.new
				@front_end			=	nil
				@back_end			=	nil
				@requires_prefix	=	false;
				@default_fe			=	default_fe
			end

			def set_front_end fe

				raise ::TypeError, "front-end instance (#{fe.class}) does not respond to all the required messages ([ #{Constants_::REQUIRED_FRONTEND_METHODS.join(', ')} ])" unless fe && Constants_::REQUIRED_FRONTEND_METHODS.all? { |m| fe.respond_to? m }

				r	=	nil

				fe	||=	@default_fe

				@mx_service.synchronize do

					r, @front_end = @front_end, fe
				end

				r = nil if r.object_id == @default_fe.object_id

				return r
			end

			def set_back_end be

				raise ::TypeError, "back-end instance (#{fe.class}) does not respond to all the required messages ([ #{Constants_::REQUIRED_BACKEND_METHODS.join(', ')} ])" unless be && Constants_::REQUIRED_BACKEND_METHODS.all? { |m| be.respond_to? m }

				r	=	nil
				srp	=	be.respond_to?(:requires_prefix?) ? be.requires_prefix? : true

				@mx_service.synchronize do

					r, @back_end, @requires_prefix = @back_end, be, srp
				end

				return r
			end

			def set_service svc

				raise ::ArgumentError, 'service instance may not be nil' if svc.nil?

				raise ::TypeError, "service instance (#{svc.class}) does not respond to all the required messages ([ #{Constants_::REQUIRED_SERVICE_METHODS.join(', ')} ])" unless Constants_::REQUIRED_SERVICE_METHODS.all? { |m| svc.respond_to? m }

				nrcs	=	::Pantheios::Util::ReflectionUtil.non_root_classes svc

				raise ::TypeError, "service instance class - #{svc.class} - inherits some of the required messages - [ #{Constants_::REQUIRED_SERVICE_METHODS.join(', ')} ] - from the top-level" unless Constants_::REQUIRED_SERVICE_METHODS.all? { |m| nrcs.any? { |nr| nr.instance_methods(false).include? m } }

				r	=	[]
				srp	=	svc.respond_to?(:requires_prefix?) ? svc.requires_prefix? : true

				@mx_service.synchronize do

					r << @front_end
					r << @back_end

					@front_end, @back_end, @requires_prefix = svc, svc, srp
				end

				return r
			end

			if ::Pantheios::Globals.SYNCHRONISED_SEVERITY_LOGGED?

				def severity_logged? severity

					@mx_service.synchronize do

						return nil unless @front_end

						@front_end.severity_logged? severity
					end
				end
			else

				def severity_logged? severity

					return @front_end.severity_logged? severity
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
		end # class State
	end # module Internals_

	# @!visibility private
	def self.included receiver # :nodoc:

		abort "Attempt to include #{self} into #{receiver}. This is not allowed"
	end

	# @!visibility private
	def self.core_init # :nodoc:

		# process-name

		prg_nam	=	nil

		case Pantheios::Globals.PROCESS_NAME
		when nil

			;
		when ::Symbol

			prg_nam	=	::Pantheios::Util::ProcessUtil.derive_process_name $0, style: Pantheios::Globals.PROCESS_NAME
		when ::String

			prg_nam	=	Pantheios::Globals.PROCESS_NAME.strip
			prg_nam	=	nil if prg_name.empty?
		else

			warn "ignoring unsupported Globals.PROCESS_NAME type - '#{Pantheios::Globals.PROCESS_NAME.class}'"
		end

		@process_name = prg_nam if prg_nam


		# main thread-name
		#
		# This is obtained from Pantheios::Globals.MAIN_THREAD_NAME, which
		# may be either ::String or [ ::String, ::Thread ]

		mt_th	=	nil
		mt_nam	=	nil

		case pg_mtn = ::Pantheios::Globals.MAIN_THREAD_NAME
		when nil

			;
		when ::Array

			if pg_mtn.size != 2

				warn "ignoring array of wrong length - #{pg_mtn.size} given; 2-required - for Globals.MAIN_THREAD_TYPE"
			else

				mt_th	=	pg_mtn[0]
				mt_nam	=	pg_mtn[1]

				if ::Thread === mt_nam

					mt_th, mt_nam = mt_nam, mt_th
				end
			end
		when ::String

			mt_th	=	Thread.current
			mt_nam	=	pg_mtn
		else

			warn "ignoring unsupported Globals.MAIN_THREAD_NAME type - '#{Pantheios::Globals.MAIN_THREAD_NAME.class}'"
		end

		::Pantheios::Util::ThreadUtil.set_thread_name mt_th, mt_nam if mt_nam


		# state (incl. default service)

		@@state = Internals_::State.new Internals_::DefaultDiscriminator.new

		self.set_default_service
	end

	# @!visibility private
	def self.set_default_service **options # :nodoc:

		# determine which log service to initialise as the default

		([::Pantheios::Globals.INITIAL_SERVICE_INSTANCES].flatten || []).reject(&:nil?).each do |inst|

			next unless inst

			return @@state.set_service inst
		end

		([::Pantheios::Globals.INITIAL_SERVICE_CLASSES].flatten || []).reject(&:nil?).each do |cls|

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

	# Default implementation to obtain the process name
	#
	# * *Returns:*
	#   The file stem of +$0+
	#
	# NOTE: this is implemented in terms of
	# +Process_Util.derive_process_name+ and the result is cached
	def self.process_name

		@process_name ||= ::Pantheios::Util::ProcessUtil.derive_process_name $0
	end

	# [DEPRECATED] Use +process_name+
	def self.program_name; self.process_name; end

	# Sets the process name
	#
	# * *Parameters:*
	#   - +name+:: [String] The (new) process name. May be +nil+, in which
	#   case +process_name+ will obtain the process name from
	#   +Process_Util.derive_process_name+
	#
	# * *Returns:*
	#   The previous version
	#
	# NOTE: to reset the value, set to +nil+
	def self.process_name= name

		previous, @process_name = @process_name, name

		previous
	end

	# [DEPRECATED] Use +process_name=+
	def self.program_name= name; self.process_name = name; end

	# Obtains a string form of the given severity
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
	#
	# @!visibility private
	def self.get_block_value_ &block # :nodoc:

		case block.arity
		when 0

			yield
		when 1

			yield severity
		when 2

			yield severity, argv
		when 3

			yield severity, argv, self
		else

			warn 'too many parameters in logging block'

			yield severity, argv, self
		end
	end

	# Internal implementation method, not to be called by application code
	#
	# @!visibility private
	def self.log_v_impl prefix_provider, severity, argv, &block # :nodoc:

		argv << get_block_value_(&block) if block_given?

		self.log_raw prefix_provider, severity, argv.join
	end

	# Internal implementation method, not to be called by application code
	#
	# @!visibility private
	def self.trace_v_impl prefix_provider, call_depth, param_list, severity, argv, &block # :nodoc:

		unless param_list

			if ApplicationLayer::ParamNameList === argv[0]

				param_list	=	argv.shift
			end
		end

		if block_given?

			br = get_block_value_(&block)

			if ApplicationLayer::ParamNameList === br

				param_list	=	br
			else
				if ::Array === br

					if ApplicationLayer::ParamNameList === br[0]

						param_list	=	br.shift
					end

					argv += br
				else

					argv << br
				end
			end
		end

		fl	=	nil
		rx	=	nil
		fn	=	caller(call_depth + 1, 1)[0]

		case param_list
		when nil
			;
		when ApplicationLayer::ParamNameList

			warn "#{fn}: param_list must contain only strings or symbols" unless param_list.all? { |p| p.kind_of?(::String) || p.kind_of?(::Symbol) }
		else

			warn "#{fn}: param_list (#{param_list.class}) must be nil or an instance of #{ApplicationLayer::ParamNameList}" unless param_list
		end

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
	#
	# @!visibility private
	def self.log_raw prefix_provider, severity, message # :nodoc:

		now	=	Time.now

		srp	=	@@state.requires_prefix?

		case srp
		when false

			prf = nil
		when true

			prf = '[' + prefix_provider.prefix(now, severity) + ']: '
		when :parts

			prf = prefix_provider.prefix_parts(now, severity)
		else

			warn "invalid value '#{srp}' returned by #requires_prefix? of the Pantheios Core's state's service (which is of type #{@@state.service.class}"

			prf = nil
		end

		@@state.back_end.log severity, now, prf, message
	end

end # Core
end # Pantheios

# ############################## end of file ############################# #


