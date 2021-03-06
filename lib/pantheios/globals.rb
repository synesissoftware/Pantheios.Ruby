
# ######################################################################## #
# File:         lib/pantheios/globals.rb
#
# Purpose:      The Pantheios.Ruby "globals" (::Pantheios::Globals)
#
# Created:      24th December 2017
# Updated:      3rd June 2020
#
# Home:         http://github.com/synesissoftware/Pantheios-Ruby
#
# Author:       Matthew Wilson
#
# Copyright (c) 2019-2020, Matthew Wilson and Synesis Information Systems
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
#
# === Variables
#
# * *HAS_CASCADED_INCLUDES* [boolean] Determines whether including
#   +::Pantheios+ also includes all relevant parts of subordinate
#   namespaces. See the documentation for the +::Pantheios+ namespace for
#   further details
#
# * *INITIAL_SERVICE_CLASSES* [ svc-class, [ svc-class ] ] Specifies
#   the service class(es) that will be used to create the initial service
#   instance. Ignored if INITIAL_SERVICE_INSTANCES specifies an instance
#
# * *INITIAL_SERVICE_INSTANCES* [ svc-instance, [ svc-instance ] ] Specifies
#   the initial service instance
#
# * *MAIN_THREAD_NAME* A string specifying the main thread name, or an array
#   containing a thread instance and a string specifying the thread and its
#   name
#
#   NOTE: This feature is subject to the initialising threads: if the string
#   form is used then the first initialising thread of Pantheios.Ruby will
#   be the named thread
#
# * *PROCESS_NAME* A string specifying the process name, or one of the
#   recognised symbols - :script, :script_basename, :script_dirname,
#   :script_realpath, :script_stem - that directs inference of the process
#   name. See +Pantheios::Util::ProcessUtil::derive_process_name+
#
# * *SYNCHRONISED_SEVERITY_LOGGED* [boolean] Determines whether the core
#   protects the call to the underlying log-service's +severity_logged?+
#   with a mutex (which has a non-trivial cost).
#
module Globals

	# @!visibility private
	module Internals_ # :nodoc: all

		BOOLEAN_CLASSES			=	[ ::FalseClass, ::TrueClass ]
		TRUTHY_CLASSES			=	BOOLEAN_CLASSES + [ ::NilClass ]

		PROCESS_NAME_CLASSES	=	[ ::Symbol, ::String ]
	end

	# @!visibility private
	module Helpers_ # :nodoc: all

		def self.cattr receiver, name, types, initial_value, **options

			if options[:boolean] && types.nil?

				types = Internals_::TRUTHY_CLASSES
			end

			types = nil if !types.nil? && types.empty?

			receiver.class_eval do

				field_name	=	'@' + name
				get_name	=	name
				get_name	+=	'?' if options[:boolean]

				instance_variable_set field_name, initial_value

				define_singleton_method(get_name) do

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

	Helpers_.cattr self, 'MAIN_THREAD_NAME', [ ::Array, ::String ], nil

	Helpers_.cattr self, 'PROCESS_NAME', Internals_::PROCESS_NAME_CLASSES, nil

	Helpers_.cattr self, 'SYNCHRONISED_SEVERITY_LOGGED', nil, true, boolean: true

	# @!visibility private
	def self.included receiver # :nodoc:

		abort "Attempt to include #{self} into #{receiver}. This is not allowed"
	end

end # module Globals
end # module Pantheios

# ############################## end of file ############################# #


