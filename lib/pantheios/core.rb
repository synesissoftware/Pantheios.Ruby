
# ######################################################################## #
# File:         lib/pantheios/core.rb
#
# Purpose:      The Pantheios.Ruby core (::Pantheios::Core)
#
# Created:      2nd April 2011
# Updated:      24th December 2017
#
# Home:         http://github.com/synesissoftware/Pantheios-Ruby
#
# Author:       Matthew Wilson
#
# Copyright (c) 2011-2017, Matthew Wilson and Synesis Software
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

=begin
=end

module Pantheios
module Core

	def self.included receiver

		abort "Attempt to include #{self} into #{receiver}. This is not allowed"
	end

	# :nodoc:
	def self.register_include includee, includer

$stderr.puts "#{includee} included into #{includer}"
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

		return true if $DEBUG

		levels = ::Pantheios::ApplicationLayer::StockSeverityLevels::STOCK_SEVERITY_LEVEL_VALUES

		v_info = levels[:informational]
		v_sev = levels[severity] if ::Symbol === severity

		return false if v_sev > v_info

		true
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
	def self.log_raw prefix_provider, severity, statement

		now = Time.now

		$stderr.puts "[#{prefix_provider.prefix now, severity}]: #{statement}"
	end

end # Core
end # Pantheios


