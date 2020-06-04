
# ######################################################################## #
# File:         lib/pantheios/front_ends/threshold_front_end.rb
#
# Purpose:      Definition of the ::Pantheios::FrontEnds::ThresholdFrontEnd
#               class
#
# Created:      3rd June 2020
# Updated:      4th June 2020
#
# Home:         http://github.com/synesissoftware/Pantheios-Ruby
#
# Author:       Matthew Wilson
#
# Copyright (c) 2020, Matthew Wilson and Synesis Information Systems
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

require 'pantheios/application_layer/stock_severity_levels'

module Pantheios
module FrontEnds

# A class that fulfils the Pantheios *FrontEnd* protocol that implements
# +severity_logged?+ based on a threshold specified to the initialiser
#
# NOTE: The *FrontEnd* protocol is implemented by a class that provides
# the instance method +severity_logged?(severity : Object)+
class ThresholdFrontEnd

	# Initialises the instance
	#
	# === Signature
	#
	# * *Parameters:*
	#   - +threshold_severity+ [ ::Symbol ] The threshold severity
	#
	# * *Options:*
	#   - +value_lookup_map+ [ ::Hash ] A map that is used to lookup
	#     +severity+ values (that are not +::Integer+) in
	#     +severity_logged?+. May be +nil+, in which case
	#     +::Pantheios::ApplicationLayer::StockSeverityLevels::STOCK_SEVERITY_LEVEL_VALUES+
	#     is used
	#
	# * *Exceptions:*
	#   - +::TypeError+ raised if a value given for +:value_lookup_map+ is
	#     not a ::hash
	def initialize(threshold_severity, **options)

		m = options[:value_lookup_map]

		raise TypeError, "value given for :value_lookup_map must be a #{::Hash}" if m && !m.respond_to?(:to_hash)

		if m

			@value_lookup_map = m
			@relativity_lookup_map = ::Hash.new(:relative)
		else

			@value_lookup_map = ::Pantheios::ApplicationLayer::StockSeverityLevels::STOCK_SEVERITY_LEVEL_VALUES
			@relativity_lookup_map = ::Pantheios::ApplicationLayer::StockSeverityLevels::STOCK_SEVERITY_LEVELS_RELATIVE
		end

		self.threshold = threshold_severity
	end

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

		case severity
		when ::Integer

			v = severity
		else

			v = @value_lookup_map[severity] or warn "unknown severity level '#{severity}' (#{severity.class})"
		end

		return true if v.nil?

		v <= @threshold_v
	end

	# assigns the threshold
	#
	# * *Parameters:*
	#   - +threshold_severity+ [ ::Symbol ] The threshold severity
	def threshold=(threshold_severity)

		raise TypeError, "threshold_severity must be a #{::Symbol}" unless ::Symbol === threshold_severity

		@threshold_v = @value_lookup_map[threshold_severity] if @relativity_lookup_map[threshold_severity] or raise ArgumentError, "unknown threshold severity level '#{threshold_severity}' (#{threshold_severity.class})"
		@threshold = threshold_severity

		nil
	end
	attr_reader :threshold

end # class ThresholdFrontEnd

end # module FrontEnds
end # module Pantheios

# ############################## end of file ############################# #


