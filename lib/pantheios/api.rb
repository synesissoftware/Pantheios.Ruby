
# ######################################################################## #
# File:         lib/pantheios/api.rb
#
# Purpose:      The Pantheios.Ruby API (::Pantheios::API)
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


=begin
=end


require 'pantheios/application_layer/param_name_list'
require 'pantheios/application_layer/stock_severity_levels'
require 'pantheios/util/version_util'

require 'pantheios/core'


module Pantheios
# This inclusion module specifies the main logging API methods, including:
#
# - log
# - log_v
# - trace
# - trace_v
#
# as well as those that may be overridden:
#
# - severity_logged?
# - tracing?
#
# - prefix_elements
# - process_id
# - program_name
# - severity_string severity
# - thread_id
# - timestamp dt
module API

	# Logs an arbitrary set of parameters at the given severity level
	def log severity, *args

		return nil unless severity_logged? severity

		log_or_trace 1, severity, args
	end

	# Logs an array of parameters at the given severity level
	def log_v severity, argv

		return nil unless severity_logged? severity

		log_or_trace 1, severity, argv
	end

	# Logs an arbitrary set of parameters at the Trace (:trace) level
	def trace *args

		return nil unless tracing?

		::Pantheios::Core.trace_v_prep self, 1, args
	end

	# Logs an array of parameters at the Trace (:trace) level
	def trace_v argv

		return nil unless tracing?

		::Pantheios::Core.trace_v_prep self, 1, argv
	end

	if Util::VersionUtil.version_compare(RUBY_VERSION, [ 2, 1 ]) >= 0

	def trace_blv b, lvars

		return nil unless tracing?

		::Pantheios::Core.trace_v_impl self, 1, ApplicationLayer::ParamNameList[*lvars], :trace, lvars.map { |lv| b.local_variable_get(lv) }
	end
	end # RUBY_VERSION

	if Util::VersionUtil.version_compare(RUBY_VERSION, [ 2, 2 ]) >= 0

	def trace_b b

		return nil unless tracing?

		::Pantheios::Core.trace_v_impl self, 1, ApplicationLayer::ParamNameList[*b.local_variables], :trace, b.local_variables.map { |lv| b.local_variable_get(lv) }
	end
	end # RUBY_VERSION


	# Determines whether a given severity is logged
	#
	# === Signature
	#
	# * *Parameters:*
	#   - +severity+:: The severity level, which should be a known log
	#   severity symbol or an integral equivalent
	#
	# * *Returns:*
	#   a +truey+ value if the severity should be logged; a +falsey+ value
	#   otherwise
	def severity_logged? severity

		::Pantheios::Core.severity_logged? severity
	end

	# Determines whether tracing (severity == :trace) is enabled. This is
	# used in the trace methods (+trace+, +trace_v+, +trace_blv+, +trace_b+)
	# and therefore it may be overridden independently of +severity_logged?+
	def tracing?

		severity_logged? :trace
	end



	# Defines the ordered list of log-statement elements
	#
	# === Elements
	#
	# Elements can be one of:
	#   - +:program_name+
	#   - +:process_id+
	#   - +:severity+
	#   - +:thread_id+
	#   - +:timestamp+
	#
	# This is called from +prefix+
	def prefix_elements

		[ :program_name, :thread_id, :timestamp, :severity ]
	end

	# Obtains the process id
	#
	# Unless overridden, returns the value provided by
	# +::Pantheios::Core::process_id+
	def process_id

		::Pantheios::Core.process_id
	end

	# Obtains the program name
	#
	# Unless overridden, returns the value provided by
	# +::Pantheios::Core::program_name+
	def program_name

		::Pantheios::Core.program_name
	end

	# Obtains the string corresponding to the severity
	#
	# Unless overridden, returns the value provided by
	# +::Pantheios::Core::severity_string+
	def severity_string severity

		::Pantheios::Core.severity_string severity
	end

	# Obtains the thread id
	#
	# Unless overridden, returns the value provided by
	# +::Pantheios::Core::thread_id+
	def thread_id

		::Pantheios::Core.thread_id
	end

	# Obtains a string-form of the timestamp
	#
	# Unless overridden, returns the value provided by
	# +::Pantheios::Core::timestamp+
	def timestamp dt

		::Pantheios::Core.timestamp dt, nil
	end

	def prefix t, severity

		prefix_elements.map do |el|

			case el
			when :program_name

				program_name
			when :process_id

				process_id
			when :severity

				severity_string severity
			when :thread_id

				thread_id
			when :timestamp

				timestamp t
			else

				s = ::Symbol === el ? ":#{el}" : el.to_s

				warn "ignoring unrecognised prefix_element '#{s}'"

				nil
			end
		end.join(', ') # TODO: need to do more intelligent joining
	end


	def self.included receiver

		receiver.extend self

		::Pantheios::Core.register_include self, receiver
	end

	private

	# Private implementation method that should not need to be overridden
	def log_or_trace call_depth, severity, argv

		if :trace == severity

			return ::Pantheios::Core.trace_v_impl self, 1 + call_depth, nil, severity, argv
		end

		::Pantheios::Core.log_raw self, severity, argv.join
	end

end # module API
end # module Pantheios


