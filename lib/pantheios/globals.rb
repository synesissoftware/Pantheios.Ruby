
# ######################################################################## #
# File:         lib/pantheios/globals.rb
#
# Purpose:      The Pantheios.Ruby "globals" (::Pantheios::Globals)
#
# Created:      24th December 2017
# Updated:      8th January 2018
#
# Home:         http://github.com/synesissoftware/Pantheios-Ruby
#
# Author:       Matthew Wilson
#
# Copyright (c) 2017-2018, Matthew Wilson and Synesis Software
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
# A utility namespace for the sole purpose of defining "globals" - actually
# module constants' values and module attributes - that control the
# behaviour of Pantheios globally
#
# NOTE: The "globals" in this namespace are operative before
# +::Pantheios::Core+ and +::Pantheios::API+
module Globals

	module Internals_

		BOOLEAN_CLASSES	=	[ ::FalseClass, ::TrueClass ]
		TRUTHY_CLASSES	=	BOOLEAN_CLASSES + [ ::NilClass ]
	end

	module Helpers_

		def self.cattr receiver, name, types, initial_value

			types = nil if !types.nil? && types.empty?

			receiver.class_eval do

				field_name = '@' + name

				instance_variable_set field_name, initial_value

				define_singleton_method(name) do

					instance_variable_get field_name
				end

				define_singleton_method(name + '=') do |v|

					if types

						warn "Assigning to #{__method__} with argument of invalid type - #{v.class} given; one of #{types.join(', ')} required" unless types.any? { |c| c === v }
					end

					instance_variable_set field_name, v
				end
			end
		end
	end

	Helpers_.cattr self, 'HAS_CASCADED_INCLUDES', Internals_::BOOLEAN_CLASSES, true

	Helpers_.cattr self, 'INITIAL_SERVICE_INSTANCES', nil, nil

	Helpers_.cattr self, 'INITIAL_SERVICE_CLASSES', nil, nil

	def self.included receiver

		abort "Attempt to include #{self} into #{receiver}. This is not allowed"
	end

end # module Globals
end # module Pantheios

# ############################## end of file ############################# #


