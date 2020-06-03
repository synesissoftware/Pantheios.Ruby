
# ######################################################################## #
# File:         lib/pantheios/application_layer/stock_severity_levels.rb
#
# Purpose:      Definition of the
#               Pantheios::ApplicationLayer::StockSeverityLevels include /
#               namespace module
#
# Created:      2nd April 2011
# Updated:      3rd June 2020
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


=begin
=end

module Pantheios
module ApplicationLayer

module StockSeverityLevels

	private
	module Internal_

		STOCK_SEVERITY_LEVELS_ = {

			:violation => [ 1, 'Violation', :relative, [ :emergency ] ],
			:alert => [ 2, 'Alert', :relative ],
			:critical => [ 3, 'Critical', :relative ],
			:failure => [ 4, 'Failure', :relative, [ :fail ] ],
			:warning => [ 5, 'Warning', :relative, [ :warn ] ],
			:notice => [ 6, 'Notice', :relative ],
			:informational => [ 7, 'Informational', :relative, [ :info ] ],
			:debug0 => [ 8, 'Debug-0', :relative ],
			:debug1 => [ 9, 'Debug-1', :relative ],
			:debug2 => [ 10, 'Debug-2', :relative ],
			:debug3 => [ 11, 'Debug-3', :relative ],
			:debug4 => [ 12, 'Debug-4', :relative ],
			:debug5 => [ 13, 'Debug-5', :relative ],
			:trace => [ 15, 'Trace', :relative ],
			:benchmark => [ 16, 'Benchmark', :separate ],
		}

		def self.create_level_keys m

			r = m.keys

			m.each do |k, ar|

				(ar[3] || []).each do |al|

					r << al
				end
			end

			r.uniq
		end

		def self.create_level_value_map m

			r = {}

			m.each do |s, ar|

				warn 'invalid start-up' unless ::Symbol === s
				warn 'invalid start-up' unless ::Array === ar

				([s] + (ar[3] || [])).each do |al|

					r[al] = ar[0]
				end
			end

			r
		end

		def self.create_level_string_map m

			r = {}

			m.each do |s, ar|

				warn 'invalid start-up' unless ::Symbol === s
				warn 'invalid start-up' unless ::Array === ar

				([s] + (ar[3] || [])).each do |al|

					r[al] = ar[1]
				end
			end

			r
		end

		def self.create_level_aliases m

			r = {}

			m.each do |s, ar|

				warn 'invalid start-up' unless ::Symbol === s
				warn 'invalid start-up' unless ::Array === ar

				([s] + (ar[3] || [])).each do |al|

					r[al] = s
				end
			end

			r
		end

		def self.create_level_relative_map m

			r = {}

			m.each do |s, ar|

				warn 'invalid start-up' unless ::Symbol === s
				warn 'invalid start-up' unless ::Array === ar

				relativity = ar[2]

				case relativity
				when :relative

					([s] + (ar[3] || [])).each do |al|

						r[al] = relativity
					end
				else

					;
				end
			end

			r
		end
	end
	public

	# Ordered list of stock severity level symbols, without any aliases
	STOCK_SEVERITY_LEVELS_PRIME = Internal_::STOCK_SEVERITY_LEVELS_.keys

	# Unordered list of stock severity levels, some of which may be aliases
	STOCK_SEVERITY_LEVELS = Internal_.create_level_keys Internal_::STOCK_SEVERITY_LEVELS_

	# Mapping of severity level aliases - with may be symbols and strings -
	# to the prime stock severity level symbols
	STOCK_SEVERITY_LEVEL_ALIASES = Internal_.create_level_aliases Internal_::STOCK_SEVERITY_LEVELS_

	# Mapping of severity level aliases - with may be symbols and strings -
	# containing only those levels that are relative, i.e. may participate
	# meaningfully in a threshold-based filtering
	STOCK_SEVERITY_LEVELS_RELATIVE = Internal_.create_level_relative_map Internal_::STOCK_SEVERITY_LEVELS_

	# Mapping of severity level (and level alias) symbols to integral
	# equivalent
	STOCK_SEVERITY_LEVEL_VALUES = Internal_.create_level_value_map Internal_::STOCK_SEVERITY_LEVELS_

	# Mapping of severity level (and level alias) symbols to string
	STOCK_SEVERITY_LEVEL_STRINGS = Internal_.create_level_string_map Internal_::STOCK_SEVERITY_LEVELS_

end # module StockSeverityLevels

end # module ApplicationLayer
end # module Pantheios

# ############################## end of file ############################# #


