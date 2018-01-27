
# ######################################################################## #
# File:         lib/pantheios/services/standard_log_service_adapter.rb
#
# Purpose:      Definition of the
#               ::Pantheios::Services::StandardLogServiceAdapter class
#
# Created:      18th June 2015
# Updated:      23rd January 2018
#
# Home:         http://github.com/synesissoftware/Pantheios-Ruby
#
# Author:       Matthew Wilson
#
# Copyright (c) 2015-2018, Matthew Wilson and Synesis Software
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


require 'pantheios/application_layer/stock_severity_levels'

require 'pantheios/util/process_util'

require 'xqsr3/quality/parameter_checking'

require 'logger'

=begin
=end

module Pantheios
module Services

# An adapter class that fulfils the Pantheios *LogService* protocol in terms
# an instance of the standard Ruby logger
#
# NOTE: The *LogService* protocol is implemented by a class that provides
# the instance methods +severity_logged?(severity : Object) : boolean+ and
# +log(severity : Object, t : Time, prefix : String, msg : String)+
class StandardLogServiceAdapter

	include ::Xqsr3::Quality::ParameterChecking

	STOCK_SEVS_EXT2NUM = ::Pantheios::ApplicationLayer::StockSeverityLevels::STOCK_SEVERITY_LEVEL_VALUES

	SEV_LEVELS_INT2PAIR = {

		::Logger::DEBUG => [ :debug0, STOCK_SEVS_EXT2NUM[:debug0] ],
		::Logger::WARN => [ :warning, STOCK_SEVS_EXT2NUM[:warning] ],
		::Logger::ERROR => [ :failure, STOCK_SEVS_EXT2NUM[:failure] ],
		::Logger::FATAL => [ :alert, STOCK_SEVS_EXT2NUM[:alert] ],
		::Logger::UNKNOWN => [ :violation, STOCK_SEVS_EXT2NUM[:violation] ],
	}

	SEV_LEVELS_EXT2INT = {

		:trace => ::Logger::DEBUG,
		:benchmark => ::Logger::DEBUG,

		:debug0 => ::Logger::DEBUG,
		:debug1 => ::Logger::DEBUG,
		:debug2 => ::Logger::DEBUG,
		:debug3 => ::Logger::DEBUG,
		:debug4 => ::Logger::DEBUG,

		:notice => ::Logger::INFO,
		:informational => ::Logger::INFO, :info => ::Logger::INFO,

		:warning => ::Logger::WARN, :warn => ::Logger::WARN,

		:failure => ::Logger::ERROR, :error => ::Logger::ERROR,
		:critical => ::Logger::ERROR,

		:alert => ::Logger::UNKNOWN,
		:violation => ::Logger::UNKNOWN, :emergency => ::Logger::UNKNOWN,
	}

	SEV_LEVELS_EXT2NUM = {

		STOCK_SEVS_EXT2NUM[:trace] => ::Logger::DEBUG,
		STOCK_SEVS_EXT2NUM[:benchmark] => ::Logger::DEBUG,

		STOCK_SEVS_EXT2NUM[:debug0] => ::Logger::DEBUG,
		STOCK_SEVS_EXT2NUM[:debug1] => ::Logger::DEBUG,
		STOCK_SEVS_EXT2NUM[:debug2] => ::Logger::DEBUG,
		STOCK_SEVS_EXT2NUM[:debug3] => ::Logger::DEBUG,
		STOCK_SEVS_EXT2NUM[:debug4] => ::Logger::DEBUG,

		STOCK_SEVS_EXT2NUM[:notice] => ::Logger::INFO,
		STOCK_SEVS_EXT2NUM[:informational] => ::Logger::INFO,

		STOCK_SEVS_EXT2NUM[:warning] => ::Logger::WARN,

		STOCK_SEVS_EXT2NUM[:failure] => ::Logger::ERROR,
		STOCK_SEVS_EXT2NUM[:critical] => ::Logger::ERROR,

		STOCK_SEVS_EXT2NUM[:alert] => ::Logger::UNKNOWN,
		STOCK_SEVS_EXT2NUM[:violation] => ::Logger::UNKNOWN,
	}


	def initialize logger, adapter_threshold = nil, **options

		check_parameter logger, 'logger', responds_to: [ :add, :level, :level= ]
		check_parameter adapter_threshold, 'adapter_threshold', types: [ ::Integer, ::Symbol ], allow_nil: true
		format = check_option options, :format, type: ::Symbol, values: [ :default, :simple, :standard ], allow_nil: true

		@logger				=	logger
		@format				=	format || :default
		@adapter_threshold	=	adapter_threshold
		@at_value			=	nil
		@closed				=	false
	end

	# The threshold of the adapter, as expressed in a Pantheios severity
	# level
	#
	# NOTE: may be +nil+, in which case the decision to determine whether to
	# log (in the form of the +severity_logged?+ method) will be defered to
	# the underlying logger.
	attr_reader :adapter_threshold

	def adapter_threshold= threshold

		case @adapter_threshold	=	threshold
		when nil

			@at_value	=	nil
		when ::Symbol

			@at_value	=	STOCK_SEVS_EXT2NUM[threshold]
		when ::Integer

			@at_value	=	threshold
		else

			raise ::TypeError, 'adapter_threshold must be a symbol, an integer value, or nil'
		end
	end

	def close

		raise "already closed" if @closed

		@logger.close

		@closed = true
	end

	def flush

		@logger.flush if @logger.respond_to? :flush
	end

	def severity_logged? severity

		case severity
		when nil

			return true
		when adapter_threshold

			return true
		when ::Symbol

			sev	=	STOCK_SEVS_EXT2NUM[severity] || 0
		when ::Integer

			sev	=	severity
		else

			warn "severity - '#{severity}' - of invalid type (#{severity.class}) specified to severity_logged?"

			return true
		end


		unless adapter_threshold

			# ask the logger

			sym, val = SEV_LEVELS_INT2PAIR[@logger.level]

			return sev <= val
		end


		return sev <= @at_value
	end

	def log severity, t, prefix, msg

		sev_ext		=	STOCK_SEVS_EXT2NUM[severity]
		sev_ext		||=	severity if ::Integer === severity
		sev_int		=	SEV_LEVELS_EXT2NUM[sev_ext]
		sev_int		||=	::Logger::UNKNOWN

		case @format
		when :default

			prog_name	=	::Pantheios::Util::ProcessUtil.derive_process_name $0

			@logger.add sev_int, msg, prog_name
		when :simple

			@logger << msg + ?\n
		when :standard

			@logger << "#{prefix}#{msg}\n"
		end
	end
end

end # module Services
end # module Pantheios

# ############################## end of file ############################# #


